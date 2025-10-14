import React, { useState, useEffect } from "react";
import axios from "axios";

const SeatSelection = ({ showtime }) => {
    const [seats, setSeats] = useState([]);
    const [selectedSeats, setSelectedSeats] = useState([]);
    const [loading, setLoading] = useState(true);

    // Fetch seats for the showtime
    const fetchSeats = async () => {
        if (!showtime?.id) return;
        setLoading(true);
        try {
            const token = localStorage.getItem("token");
            const res = await axios.get(
                `http://localhost:3000/showtimes/${showtime.id}/available_seats`,
                { headers: { Authorization: `Bearer ${token}` } }
            );
            // Ensure res.data is an array
            setSeats(Array.isArray(res.data) ? res.data : []);
        } catch (err) {
            console.error(err);
            alert("Failed to load seats.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchSeats();
        setSelectedSeats([]); // reset selections on showtime change

        // Listen for seat-refresh events
        const handleSeatRefresh = (e) => {
            if (e.detail.showtimeId === showtime.id) {
                fetchSeats(); // reload seats for this showtime
            }
        };

        window.addEventListener("seat-refresh", handleSeatRefresh);

        // Cleanup on unmount or showtime change
        return () => {
            window.removeEventListener("seat-refresh", handleSeatRefresh);
        };
    }, [showtime]);

    const toggleSeat = (seat) => {
        if (!seat.available) return;
        setSelectedSeats((prev) =>
            prev.includes(seat.id)
                ? prev.filter((id) => id !== seat.id)
                : [...prev, seat.id]
        );
    };

    const handleBook = async () => {
        if (selectedSeats.length === 0) {
            alert("Please select at least one seat.");
            return;
        }
        try {
            const token = localStorage.getItem("token");
            const res = await axios.patch(
                `http://localhost:3000/showtimes/${showtime.id}/book_seats`,
                { seat_ids: selectedSeats },
                { headers: { Authorization: `Bearer ${token}` } }
            );

            alert("Seats booked successfully!");
            setSelectedSeats([]);
            fetchSeats(); // refresh seats after booking
        } catch (err) {
            console.error(err);
            alert(err.response?.data?.error || "Error booking seats.");
        }
    };

    if (loading) return <p>Loading seats...</p>;

    // Organize seats by row
    const seatsByRow = seats.reduce((acc, seat) => {
        if (!acc[seat.row]) acc[seat.row] = [];
        acc[seat.row].push(seat);
        return acc;
    }, {});

    Object.keys(seatsByRow).forEach((row) => {
        seatsByRow[row].sort((a, b) => a.seat_number - b.seat_number);
    });

    // Total price and seat numbers
    const selectedSeatObjects = seats.filter((s) => selectedSeats.includes(s.id));
    const totalPrice = selectedSeatObjects.reduce((sum, s) => sum + Number(s.price ?? 0), 0);
    const seatNumbers = selectedSeatObjects.map((s) => `${s.row}${s.seat_number}`).join(", ");

    return (
        <div>
            <h4>Select Seats:</h4>

            {/* Color Legend */}
            <div style={{ display: "flex", marginBottom: "10px", gap: "15px" }}>
                <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                    <div style={{ width: "20px", height: "20px", backgroundColor: "#eee", border: "1px solid #ccc" }}></div>
                    <span>Available</span>
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                    <div style={{ width: "20px", height: "20px", backgroundColor: "#1e90ff", border: "1px solid #ccc" }}></div>
                    <span>Selected</span>
                </div>
                <div style={{ display: "flex", alignItems: "center", gap: "4px" }}>
                    <div style={{ width: "20px", height: "20px", backgroundColor: "#444", border: "1px solid #ccc" }}></div>
                    <span>Booked</span>
                </div>
            </div>

            {/* Seat grid */}
            {Object.keys(seatsByRow).map((row) => (
                <div key={row} style={{ display: "flex", marginBottom: "4px" }}>
                    <span style={{ width: "20px" }}>{row}</span>
                    {seatsByRow[row].map((seat) => (
                        <div
                            key={seat.id}
                            onClick={() => toggleSeat(seat)}
                            title={`${seat.seat_type || "N/A"} - ₹${seat.price ?? 0}`}
                            style={{
                                width: "30px",
                                height: "30px",
                                margin: "2px",
                                backgroundColor: !seat.available
                                    ? "#444"
                                    : selectedSeats.includes(seat.id)
                                        ? "#1e90ff"
                                        : "#eee",
                                color: "#000",
                                textAlign: "center",
                                lineHeight: "30px",
                                cursor: seat.available ? "pointer" : "not-allowed",
                                borderRadius: "4px",
                                border: "1px solid #ccc",
                                fontSize: "12px",
                                transition: "0.2s",
                            }}
                        >
                            {seat.seat_number}
                        </div>
                    ))}
                </div>
            ))}

            {/* Selected seats & total */}
            {selectedSeats.length > 0 && (
                <p style={{ fontWeight: "bold", marginTop: "10px" }}>
                    Selected Seats: {seatNumbers} <br />
                    Total: ₹{totalPrice.toFixed(2)}
                </p>
            )}

            <button
                style={{
                    marginTop: "10px",
                    padding: "8px 12px",
                    borderRadius: "6px",
                    backgroundColor: "#1e90ff",
                    color: "#fff",
                    border: "none",
                    cursor: "pointer",
                }}
                onClick={handleBook}
            >
                Book Selected Seats
            </button>
        </div>
    );
};

export default SeatSelection;
