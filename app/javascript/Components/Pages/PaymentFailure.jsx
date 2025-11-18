import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";

const PaymentFailure = () => {
    const [txnid, setTxnid] = useState("");
    const [error, setError] = useState("");
    const navigate = useNavigate();

    useEffect(() => {

        const token = localStorage.getItem("token");
        if (!token) {
            setError("User not logged in.");
            navigate("/login");
            return;
        }

        const params = new URLSearchParams(window.location.search);
        const id = params.get("txnid");
        const status = params.get("status");

        if (!id) {
            setError("Invalid transaction.");
            return;
        }

        axios
            .get(`/payments/failure.json`, {
                params: { txnid: id, status },
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            })
            .then(() => {
                setTxnid(id);
            })
            .catch((err) => {
                console.error("Error:", err);

                if (err.response?.status === 401) {
                    setError("Unauthorized access.");
                    navigate("/login");
                } else {
                    setError("Could not verify transaction.");
                }
            });
    }, [navigate]);

    if (error) {
        return <p style={{ color: "red", textAlign: "center" }}>{error}</p>;
    }

    return (
        <div
            style={{
                maxWidth: "600px",
                margin: "50px auto",
                padding: "30px",
                backgroundColor: "#fff",
                boxShadow: "0 0 15px rgba(0,0,0,0.2)",
                borderRadius: "12px",
                textAlign: "center",
                fontFamily: "Arial, sans-serif",
            }}
        >
            <h2 style={{ color: "#d32f2f" }}>❌ Payment Failed</h2>
            <h3 style={{ marginBottom: "20px" }}>We couldn’t process your payment.</h3>

            <p><strong>Transaction ID:</strong> {txnid}</p>

            <p style={{ color: "#555", marginTop: "15px" }}>
                Don’t worry — sometimes this happens due to a network issue or timeout.
                You can try again or check your bookings later.
            </p>

            <div
                style={{
                    marginTop: "30px",
                    display: "flex",
                    gap: "15px",
                    justifyContent: "center",
                    flexWrap: "wrap",
                }}
            >
                <button
                    onClick={() => navigate("/")}
                    style={{
                        backgroundColor: "#1976d2",
                        color: "white",
                        border: "none",
                        padding: "10px 20px",
                        borderRadius: "8px",
                        cursor: "pointer",
                    }}
                >
                    🔁 Try Again
                </button>

                <button
                    onClick={() => navigate("/dashboard")}
                    style={{
                        backgroundColor: "#2e7d32",
                        color: "white",
                        border: "none",
                        padding: "10px 20px",
                        borderRadius: "8px",
                        cursor: "pointer",
                    }}
                >
                    Go to Dashboard
                </button>
            </div>
        </div>
    );
};

export default PaymentFailure;
