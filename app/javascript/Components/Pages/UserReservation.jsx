import React, { useState, useEffect } from "react";
import axios from "axios";
import SeatSelection from "./SeatSelection";

const formatDay = (dateStr) => {
    const date = new Date(dateStr);
    return date.toLocaleDateString("en-US", {
        weekday: "short",
        day: "2-digit",
        month: "short",
        year: "numeric",
    });
};
const formatTime = (dateStr) => {
    const date = new Date(dateStr);
    return date.toLocaleTimeString("en-US", { hour: '2-digit', minute: '2-digit' });
};

const UserReservation = ({ movieId }) => {
    const [date, setDate] = useState("");
    const [showtimes, setShowtimes] = useState([]);
    const [selectedShowtime, setSelectedShowtime] = useState(null);
    const [showModal, setShowModal] = useState(false);
    const token = localStorage.getItem("token");

    const fetchShowtimes = async () => {
        if (!date) return;
        try {
            const res = await axios.get(
                `http://localhost:3000/showtimes?movie_id=${movieId}&date=${date}`
            );
            console.log("Showtimes response:", res.data);
            setShowtimes(res.data);
            setSelectedShowtime(null);
        } catch (err) {
            console.error(err);
            alert("Failed to load showtimes.");
        }
    };

    useEffect(() => {
        if (date) fetchShowtimes();
    }, [date]);

    const showtimesByTheatre = showtimes.reduce((acc, st) => {
        const theatreName = st.screen?.theatre?.name || "Unknown Theatre";
        if (!acc[theatreName]) acc[theatreName] = [];
        acc[theatreName].push(st);
        return acc;
    }, {});

    const handleShowtimeClick = (st) => {
        if (st.available_seats === 0) return;
        setSelectedShowtime(st);
        setShowModal(true);
    };

    return (
        <div style={{ maxWidth: "900px", margin: "20px auto", padding: "20px" }}>
            <h2 style={{ textAlign: "center", marginBottom: "20px" }}>
                🎬 Book Your Movie
            </h2>


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

            {Object.keys(showtimesByTheatre).length === 0 && date && (
                <p style={{ textAlign: "center", color: "red" }}>
                    No showtimes available for this date.
                </p>
            )}

            {Object.entries(showtimesByTheatre).map(([theatreName, sts]) => (
                <div key={theatreName} style={{ marginBottom: "20px" }}>
                    <h3 style={{ borderBottom: "1px solid #ccc", paddingBottom: "5px" }}>
                        {theatreName}
                    </h3>
                    {sts.map((st) => (
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
                            onClick={() => handleShowtimeClick(st)}
                        >
                            <p>Screen: {st.screen?.name || "Unknown Screen"}</p>
                            <p>
                                {formatDay(st.start_time)} @ {formatTime(st.start_time)}
                            </p>

                        </div>
                    ))}
                </div>
            ))}


            {showModal && selectedShowtime && (
                <SeatSelection
                    showtime={selectedShowtime}
                    onClose={() => setShowModal(false)}
                />
            )}
        </div>
    );
};
export default UserReservation;