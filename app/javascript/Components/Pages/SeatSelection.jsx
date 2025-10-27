import React, { useEffect, useState } from "react";
import axios from "axios";

const seatTypeColors = {
    Regular: "#eee",
    Premium: "#ffd700",
    VIP: "#ff8c00",
    Booked: "#444",
    Selected: "#1e90ff",
};

const SeatSelection = ({ showtime, onClose }) => {
    const [seats, setSeats] = useState([]);
    const [selectedSeats, setSelectedSeats] = useState([]);
    const [loading, setLoading] = useState(false); // start false
    const token = localStorage.getItem("token");

    // Fetch seats for the showtime
    const fetchSeats = async () => {
        if (!showtime?.id) return; // don't fetch if showtime not ready
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
    }, [showtime]); // runs only when showtime changes

    const toggleSeat = (seat) => {
        if (!seat.available) return;
        setSelectedSeats((prev) =>
            prev.includes(seat.id)
                ? prev.filter((id) => id !== seat.id)
                : [...prev, seat.id]
        );
    };

    if (!showtime) return null; // don't render modal until showtime exists
    if (loading) return <p style={{ textAlign: "center" }}>Loading seats...</p>;

    // Group seats by row
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

    // Handle payment & booking
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

            // Dynamically create PayU form
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

    // Rows A-Z
    const rows = Array.from({ length: 26 }, (_, i) => String.fromCharCode(65 + i));

    return (
        <div style={{ position: "fixed", top: 0, left: 0, width: "100vw", height: "100vh", backgroundColor: "rgba(0,0,0,0.6)", display: "flex", justifyContent: "center", alignItems: "center", zIndex: 1000 }}>
            <div style={{ position: "relative", background: "#fff", padding: "20px", borderRadius: "10px", width: "90%", maxWidth: "600px", maxHeight: "80vh", overflowY: "auto", boxShadow: "0 4px 10px rgba(0,0,0,0.2)" }}>
                <button onClick={onClose} style={{ position: "absolute", top: "10px", right: "10px", background: "transparent", border: "none", fontSize: "22px", fontWeight: "bold", cursor: "pointer", color: "#333" }} title="Close">×</button>
                <h3 style={{ textAlign: "center", marginBottom: "10px" }}>🎟️ Select Your Seats</h3>

                {rows.map((row) => (
                    <div key={row} style={{ display: "flex", marginBottom: "4px" }}>
                        <span style={{ width: "20px", fontWeight: "bold" }}>{row}</span>
                        {(seatsByRow[row] || []).map((seat) => {
                            const isSelected = selectedSeats.includes(seat.id);
                            const bgColor = !seat.available ? seatTypeColors.Booked : isSelected ? seatTypeColors.Selected : seatTypeColors[seat.seat_type] || seatTypeColors.Regular;
                            return (
                                <div key={seat.id} onClick={() => toggleSeat(seat)} title={`${seat.seat_type || "Regular"} - ₹${seat.price || 0}`} style={{ width: "30px", height: "30px", margin: "2px", backgroundColor: bgColor, textAlign: "center", lineHeight: "30px", cursor: seat.available ? "pointer" : "not-allowed", borderRadius: "4px", border: "1px solid #ccc", fontSize: "12px" }}>{seat.seat_number}</div>
                            );
                        })}
                    </div>
                ))}

                {selectedSeats.length > 0 && <p style={{ fontWeight: "bold", marginTop: "10px", textAlign: "center" }}>Selected Seats: {seatNumbers} <br /> Total: ₹{totalPrice.toFixed(2)}</p>}

                <button onClick={handlePayAndBook} style={{ marginTop: "10px", padding: "8px 12px", borderRadius: "6px", backgroundColor: "#1e90ff", color: "#fff", border: "none", cursor: "pointer", display: "block", marginLeft: "auto", marginRight: "auto" }}>💳 Pay & Book ₹{totalPrice.toFixed(2)}</button>
            </div>
        </div>
    );
};

export default SeatSelection;
