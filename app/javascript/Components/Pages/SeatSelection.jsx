import React, { useEffect, useState } from "react";
import axios from "axios";
import "../Css/SeatSelection.css"; // ✅ Import the new CSS file

const SeatSelection = ({ showtime, onClose }) => {
    const [seats, setSeats] = useState([]);
    const [selectedSeats, setSelectedSeats] = useState([]);
    const [loading, setLoading] = useState(false);
    const token = localStorage.getItem("token");

    const fetchSeats = async () => {
        if (!showtime?.id) return;
        setLoading(true);
        try {
            const res = await axios.get(
                `http://localhost:3000/showtimes/${showtime.id}/available_seats`,
                { headers: { Authorization: `Bearer ${token}` } }
            );
            setSeats(Array.isArray(res.data) ? res.data : []);
            setSelectedSeats([]);
        } catch (err) {
            console.error(err);
            alert("Failed to load seats.");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchSeats();
    }, [showtime]);

    const toggleSeat = (seat) => {
        if (!seat.available) return;
        setSelectedSeats((prev) =>
            prev.includes(seat.id)
                ? prev.filter((id) => id !== seat.id)
                : [...prev, seat.id]
        );
    };

    if (!showtime) return null;
    if (loading) return <p className="loading">Loading seats...</p>;

    const seatsByRow = seats.reduce((acc, seat) => {
        if (!acc[seat.row]) acc[seat.row] = [];
        acc[seat.row].push(seat);
        return acc;
    }, {});
    Object.keys(seatsByRow).forEach((row) =>
        seatsByRow[row].sort((a, b) => a.seat_number - b.seat_number)
    );

    const selectedSeatObjects = seats.filter((s) => selectedSeats.includes(s.id));
    const totalPrice = selectedSeatObjects.reduce((sum, s) => sum + Number(s.price || 0), 0);
    const seatNumbers = selectedSeatObjects.map((s) => `${s.row}${s.seat_number}`).join(", ");

    const handlePayAndBook = async () => {
        if (selectedSeats.length === 0) {
            alert("Select at least one seat.");
            return;
        }
        try {
            const res = await axios.post(
                "http://localhost:3000/payments/initiate",
                {
                    showtime_id: showtime.id,
                    seat_ids: selectedSeats,
                    amount: totalPrice,
                    firstname: "User",
                    email: "user@gmail.com",
                    phone: "1234567890",
                    productinfo: "Movie Tickets",
                },
                { headers: { Authorization: `Bearer ${token}` } }
            );

            const data = res.data;

            const form = document.createElement("form");
            form.method = "POST";
            form.action = data.action;

            Object.keys(data).forEach((key) => {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = key;
                input.value = data[key];
                form.appendChild(input);
            });

            document.body.appendChild(form);
            form.submit();

            setSelectedSeats([]);
        } catch (err) {
            console.error(err);
            alert("Payment initiation failed.");
        }
    };

    const rows = Array.from({ length: 26 }, (_, i) => String.fromCharCode(65 + i));

    return (
        <div className="seat-overlay">
            <div className="seat-container">
                <button className="close-btn" onClick={onClose} title="Close">×</button>
                <h3 className="seat-title">🎟️ Select Your Seats</h3>

                <div className="seat-layout">
                    {rows.map((row) => (
                        <div key={row} className="seat-row">
                            <span className="row-label">{row}</span>
                            {(seatsByRow[row] || []).map((seat) => {
                                const isSelected = selectedSeats.includes(seat.id);
                                const className = [
                                    "seat",
                                    !seat.available
                                        ? "booked"
                                        : isSelected
                                            ? "selected"
                                            : seat.seat_type?.toLowerCase() || "regular",
                                ].join(" ");

                                return (
                                    <div
                                        key={seat.id}
                                        className={className}
                                        onClick={() => toggleSeat(seat)}
                                        title={`${seat.seat_type || "Regular"} - ₹${seat.price || 0}`}
                                    >
                                        {seat.seat_number}
                                    </div>
                                );
                            })}
                        </div>
                    ))}
                </div>

                {selectedSeats.length > 0 && (
                    <p className="seat-summary">
                        Selected Seats: <b>{seatNumbers}</b> <br />
                        Total: ₹{totalPrice.toFixed(2)}
                    </p>
                )}

                <button className="pay-btn" onClick={handlePayAndBook}>
                    💳 Pay & Book ₹{totalPrice.toFixed(2)}
                </button>
            </div>
        </div>
    );
};

export default SeatSelection;
