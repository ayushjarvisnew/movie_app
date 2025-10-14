import React, { useState, useEffect } from "react";
import axios from "axios";

const UserReservation = () => {
    const [date, setDate] = useState("");
    const [showtimes, setShowtimes] = useState([]);
    const [selectedShowtime, setSelectedShowtime] = useState(null);
    const [seats, setSeats] = useState(1);

    const token = localStorage.getItem("token");

    // Fetch showtimes for selected date
    const fetchShowtimes = () => {
        if (!date) return;
        axios
            .get(`http://127.0.0.1:3000/showtimes?date=${date}`, {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => setShowtimes(res.data))
            .catch((err) => console.error(err));
    };

    useEffect(() => {
        if (date) fetchShowtimes();
    }, [date]);

    // Handle reservation
    const handleReservation = () => {
        if (!selectedShowtime) return alert("Select a showtime");
        if (seats < 1) return alert("Select at least 1 seat");
        if (seats > selectedShowtime.available_seats)
            return alert("Not enough seats available");

        axios
            .post(
                "http://127.0.0.1:3000/reservations",
                { showtime_id: selectedShowtime.id, seats },
                { headers: { Authorization: `Bearer ${token}` } }
            )
            .then((res) => {
                alert("Reservation successful!");
                fetchShowtimes(); // Refresh showtimes and seats
                setSelectedShowtime(null);
                setSeats(1);
            })
            .catch((err) => {
                console.error(err);
                alert(err.response?.data?.error || "Reservation failed");
            });
    };

    return (
        <div style={{ maxWidth: "700px", margin: "20px auto", padding: "20px" }}>
            <h2 style={{ textAlign: "center", marginBottom: "20px" }}>
                Book Your Movie
            </h2>

            {/* Select Date */}
            <div style={{ marginBottom: "20px" }}>
                <label style={{ fontWeight: "bold" }}>Select Date:</label>
                <input
                    type="date"
                    value={date}
                    onChange={(e) => setDate(e.target.value)}
                    style={{
                        marginLeft: "10px",
                        padding: "6px",
                        borderRadius: "6px",
                        border: "1px solid #ccc",
                    }}
                />
            </div>

            {/* Showtimes */}
            {showtimes.length === 0 && date && (
                <p style={{ textAlign: "center", color: "red" }}>
                    No showtimes available for this date.
                </p>
            )}

            <div>
                {showtimes.map((st) => (
                    <div
                        key={st.id}
                        style={{
                            border: "1px solid #ccc",
                            borderRadius: "8px",
                            padding: "12px",
                            marginBottom: "12px",
                            backgroundColor:
                                selectedShowtime?.id === st.id ? "#f0f8ff" : "#fff",
                            cursor: st.available_seats > 0 ? "pointer" : "not-allowed",
                            opacity: st.available_seats === 0 ? 0.6 : 1,
                        }}
                        onClick={() =>
                            st.available_seats > 0 ? setSelectedShowtime(st) : null
                        }
                    >
                        <h3 style={{ margin: "0 0 5px 0" }}>{st.movie.title}</h3>
                        <p style={{ margin: "2px 0" }}>
                            Screen: {st.screen.name} | Seats Available: {st.available_seats}
                        </p>
                        <p style={{ margin: "2px 0" }}>
                            Start: {new Date(st.start_time).toLocaleString()} | End:{" "}
                            {new Date(st.end_time).toLocaleString()}
                        </p>
                        <p style={{ margin: "2px 0" }}>Language: {st.language}</p>
                        {st.available_seats === 0 && (
                            <span style={{ color: "red", fontWeight: "bold" }}>Fully booked</span>
                        )}
                    </div>
                ))}
            </div>

            {/* Seat Selection & Booking */}
            {selectedShowtime && (
                <div
                    style={{
                        marginTop: "20px",
                        display: "flex",
                        alignItems: "center",
                        gap: "10px",
                    }}
                >
                    <label style={{ fontWeight: "bold" }}>Select Seats:</label>
                    <input type="number" min="1" max={selectedShowtime.available_seats} value={seats} onChange={(e) => {
                            let val = Number(e.target.value);
                            if (val < 1) val = 1;
                            if (val > selectedShowtime.available_seats)
                                val = selectedShowtime.available_seats;
                            setSeats(val);
                        }}
                        style={{
                            width: "60px",
                            padding: "6px",
                            borderRadius: "6px",
                            border: "1px solid #ccc",
                        }}
                    />
                    <button onClick={handleReservation}
                        style={{padding: "8px 16px", backgroundColor: "#1E90FF", color: "white", border: "none", borderRadius: "6px", cursor: "pointer", fontWeight: "bold",}}>
                        Book Now
                    </button>
                </div>
            )}
        </div>
    );
};

export default UserReservation;
