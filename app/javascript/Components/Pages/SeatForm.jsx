import React, { useState, useEffect } from "react";
import axios from "axios";

const SeatForm = () => {
    const [screens, setScreens] = useState([]);
    const [screenId, setScreenId] = useState("");
    const [row, setRow] = useState("");
    const [seatNumber, setSeatNumber] = useState("");
    const [price, setPrice] = useState("");
    const [seatType, setSeatType] = useState("Regular");

    useEffect(() => {
        const token = localStorage.getItem("token");
        axios
            .get("/screens", {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => {
                const data = Array.isArray(res.data) ? res.data : [];
                setScreens(data);
            })
            .catch((err) => console.error(err));
    }, []);

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const token = localStorage.getItem("token");
            await axios.post(
                "/seats",
                {
                    seat: {
                        screen_id: parseInt(screenId),
                        row,
                        seat_number: parseInt(seatNumber),
                        seat_type: seatType,
                        price: parseFloat(price),
                        available: true,
                    },
                },
                { headers: { Authorization: `Bearer ${token}` } }
            );
            alert("Seat added successfully!");
            setRow("");
            setSeatNumber("");
            setPrice("");
            setScreenId("");
        } catch (err) {
            console.error(err);
            alert("Error adding seat.");
        }
    };

    return (
        <div
            style={{
                padding: "20px",
                maxWidth: "500px",
                margin: "0 auto",
                border: "1px solid #ccc",
                borderRadius: "8px",
                boxShadow: "0 2px 6px rgba(0,0,0,0.1)",
            }}
        >
            <h2 style={{ textAlign: "center", marginBottom: "20px" }}>Add Seat</h2>
            <form
                onSubmit={handleSubmit}
                style={{ display: "flex", flexDirection: "column", gap: "15px" }}
            >
                <select
                    value={screenId}
                    onChange={(e) => setScreenId(e.target.value)}
                    required
                    style={{ padding: "10px", borderRadius: "5px", border: "1px solid #ccc" }}
                >
                    <option value="">Select Screen</option>
                    {screens.map((s) => (
                        <option key={s.id} value={s.id}>
                            {s.name}
                        </option>
                    ))}
                </select>

                <input
                    type="text"
                    placeholder="Row (A, B, C...)"
                    value={row}
                    onChange={(e) => setRow(e.target.value)}
                    required
                    style={{ padding: "10px", borderRadius: "5px", border: "1px solid #ccc" }}
                />

                <input
                    type="number"
                    placeholder="Seat Number"
                    value={seatNumber}
                    onChange={(e) => setSeatNumber(e.target.value)}
                    required
                    style={{ padding: "10px", borderRadius: "5px", border: "1px solid #ccc" }}
                />

                <input
                    type="text"
                    placeholder="Seat Type (Regular, VIP...)"
                    value={seatType}
                    onChange={(e) => setSeatType(e.target.value)}
                    style={{ padding: "10px", borderRadius: "5px", border: "1px solid #ccc" }}
                />

                <input
                    type="number"
                    placeholder="Price"
                    value={price}
                    onChange={(e) => setPrice(e.target.value)}
                    required
                    style={{ padding: "10px", borderRadius: "5px", border: "1px solid #ccc" }}
                />

                <button
                    type="submit"
                    style={{
                        padding: "12px",
                        backgroundColor: "#007bff",
                        color: "white",
                        border: "none",
                        borderRadius: "5px",
                        cursor: "pointer",
                        fontWeight: "bold",
                        transition: "background-color 0.2s",
                    }}
                    onMouseOver={(e) => (e.target.style.backgroundColor = "#0056b3")}
                    onMouseOut={(e) => (e.target.style.backgroundColor = "#007bff")}
                >
                    Add Seat
                </button>
            </form>
        </div>
    );
};

export default SeatForm;
