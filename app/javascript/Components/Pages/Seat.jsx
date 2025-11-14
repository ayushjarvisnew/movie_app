import React, { forwardRef, useImperativeHandle, useState, useEffect } from "react";
import axios from "axios";

const Seat = forwardRef(({ onEditSeat }, ref) => {
    const [seats, setSeats] = useState([]);
    const token = localStorage.getItem("token");

    const fetchSeats = () => {
        axios
            .get("/seats", {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => {
                const data = Array.isArray(res.data) ? res.data : [];
                setSeats(data);
            })
            .catch((err) => console.error(err));
    };

    useImperativeHandle(ref, () => ({
        refreshSeats: fetchSeats,
    }));

    useEffect(() => {
        fetchSeats();
    }, []);

    const deleteSeat = (id) => {
        if (!window.confirm("Delete this seat?")) return;
        axios
            .delete(`/seats/${id}`, {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then(fetchSeats)
            .catch((err) => console.error(err));
    };

    if (!seats.length) return <p>No seats available</p>;

    return (
        <div
            style={{
                display: "grid",
                gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))",
                gap: "20px",
            }}
        >
            {seats.map((seat) => (
                <div
                    key={seat.id}
                    style={{
                        border: "1px solid #ccc",
                        borderRadius: "8px",
                        padding: "15px",
                        boxShadow: "0 1px 4px rgba(0,0,0,0.1)",
                    }}
                >
                    <h3>Seat #{seat.seat_number}</h3>
                    <p>
                        <strong>Screen:</strong> {seat.screen?.name || "N/A"}
                    </p>
                    <p>
                        <strong>Row:</strong> {seat.row || "N/A"}
                    </p>
                    <p>
                        <strong>Type:</strong> {seat.seat_type || "N/A"}
                    </p>
                    <p>
                        <strong>Price:</strong> {seat.price ?? 0}
                    </p>
                    <p>
                        <strong>Available:</strong> {seat.available ? "Yes" : "No"}
                    </p>
                    <div style={{ marginTop: "10px", display: "flex", gap: "10px" }}>
                        <button
                            onClick={() => onEditSeat(seat)}
                            style={{
                                padding: "5px 10px",
                                backgroundColor: "green",
                                color: "white",
                                border: "none",
                                borderRadius: "4px",
                            }}
                        >
                            Edit
                        </button>
                        <button
                            onClick={() => deleteSeat(seat.id)}
                            style={{
                                padding: "5px 10px",
                                backgroundColor: "red",
                                color: "white",
                                border: "none",
                                borderRadius: "4px",
                            }}
                        >
                            Delete
                        </button>
                    </div>
                </div>
            ))}
        </div>
    );
});

export default Seat;
