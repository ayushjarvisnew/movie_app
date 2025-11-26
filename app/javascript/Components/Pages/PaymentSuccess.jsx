import React, { useEffect, useState } from "react";
import axios from "axios";
import jsPDF from "jspdf";
import "jspdf-autotable";
import { useNavigate } from "react-router-dom";

const PaymentSuccess = () => {
    const [booking, setBooking] = useState(null);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    const navigate = useNavigate();

    const txnid = new URLSearchParams(window.location.search).get("txnid");
    const status = new URLSearchParams(window.location.search).get("status");

    useEffect(() => {

        const token = localStorage.getItem("token");
        if (!token) {
            setError("User not logged in.");
            navigate("/login");
            return;
        }

        if (!txnid) {
            setError("No transaction ID found in URL.");
            setLoading(false);
            return;
        }

        axios
            .get(`/payments/success.json`, {
                params: { txnid, status },
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            })

            .then((res) => {
                if (res.data.booking) {
                    setBooking(res.data.booking);
                } else {
                    setError("No booking found.");
                }
            })
            .catch((err) => {
                console.error("Error fetching booking:", err);

                if (err.response?.status === 401) {
                    setError("Unauthorized access.");
                    navigate("/login");
                } else {
                    setError("Could not load booking details.");
                }
            })
            .finally(() => setLoading(false));
    }, [txnid, status, navigate]);

    const handleDownloadTicket = () => {
        if (!booking) return;
        const doc = new jsPDF();
        doc.setFontSize(18);
        doc.text("🎟️ Movie Ticket", 14, 20);
        doc.setFontSize(12);
        doc.text(`Transaction ID: ${booking.txnid}`, 14, 35);
        doc.autoTable({
            startY: 45,
            head: [["Field", "Details"]],
            body: [
                ["Movie", booking.movie],
                ["Theatre", booking.theatre],
                ["Showtime", new Date(booking.showtime).toLocaleString()],
                ["Seats", booking.seats.join(", ")],
                ["Amount Paid", `₹${booking.amount}`],
            ],
        });
        doc.save(`Ticket_${booking.txnid}.pdf`);
    };

    if (loading) return <p>Loading booking details...</p>;
    if (error) return <p style={{ color: "red" }}>{error}</p>;

    return (
        <div
            style={{
                maxWidth: "600px",
                margin: "50px auto",
                padding: "30px",
                backgroundColor: "black",
                color:"white",
                boxShadow: "0 0 15px rgba(0,0,0,0.2)",
                borderRadius: "12px",
                textAlign: "center",
                fontFamily: "Arial, sans-serif",
            }}
        >
            <h2 style={{ color: "#ffcc00" }}>🎉 Payment Successful!</h2>
            <h3 style={{ marginBottom: "20px",color:"orange" }}>Your Booking is Confirmed</h3>

            <p><strong>Transaction ID:</strong> {booking.txnid}</p>
            <p><strong>Movie:</strong> {booking.movie}</p>
            <p><strong>Theatre:</strong> {booking.theatre}</p>
            <p><strong>Showtime:</strong> {new Date(booking.showtime).toLocaleString()}</p>
            <p><strong>Seats:</strong> {booking.seats.join(", ")}</p>
            <p><strong>Amount Paid:</strong> ₹{booking.amount}</p>

            <div style={{ marginTop: "30px", display: "flex", gap: "15px", justifyContent: "center" }}>
                <button
                    onClick={handleDownloadTicket}
                    style={{
                        backgroundColor: "#1976d2",
                        color: "white",
                        border: "none",
                        padding: "10px 20px",
                        borderRadius: "8px",
                        cursor: "pointer",
                    }}
                >
                    🎟️ Download Ticket
                </button>
            </div>
        </div>
    );
};

export default PaymentSuccess;
