import React, { useState, useEffect } from "react";
import axios from "axios";

const ShowtimeForm = ({ showtime = null, onSuccess }) => {
    const [movieId, setMovieId] = useState(showtime?.movie_id || "");
    const [screenId, setScreenId] = useState(showtime?.screen_id || "");
    const [startTime, setStartTime] = useState(showtime?.start_time || "");
    const [endTime, setEndTime] = useState(showtime?.end_time || "");
    const [language, setLanguage] = useState(showtime?.language || "");
    const [availableSeats, setAvailableSeats] = useState(showtime?.available_seats || 0);
    const [movies, setMovies] = useState([]);
    const [screens, setScreens] = useState([]);
    const token = localStorage.getItem("token");

    useEffect(() => {
        axios
            .get("http://127.0.0.1:3000/api/movies", { headers: { Authorization: `Bearer ${token}` } })
            .then((res) => setMovies(Array.isArray(res.data) ? res.data : []))
            .catch((err) => console.error(err));

        axios
            .get("http://127.0.0.1:3000/screens", { headers: { Authorization: `Bearer ${token}` } })
            .then((res) => setScreens(Array.isArray(res.data) ? res.data : []))
            .catch((err) => console.error(err));
    }, []);

    const handleSubmit = (e) => {
        e.preventDefault();
        const data = {
            showtime: {
                movie_id: parseInt(movieId),
                screen_id: parseInt(screenId),
                start_time: startTime,
                end_time: endTime,
                language,
                available_seats: parseInt(availableSeats),
            },
        };
        const url = showtime
            ? `http://127.0.0.1:3000/showtimes/${showtime.id}`
            : "http://127.0.0.1:3000/showtimes";
        const method = showtime ? "patch" : "post";

        axios({ method, url, headers: { Authorization: `Bearer ${token}`, "Content-Type": "application/json" }, data })
            .then((res) => {
                alert("Showtime saved successfully!");
                if (onSuccess) onSuccess(res.data);
            })
            .catch((err) => {
                console.error(err);
                alert("Error saving showtime.");
            });
    };

    const formGroupStyle = { display: "flex", flexDirection: "column", marginBottom: "15px" };
    const labelStyle = { marginBottom: "5px", fontWeight: "bold" };
    const inputStyle = { padding: "8px 10px", borderRadius: "6px", border: "1px solid #ccc", fontSize: "14px" };
    const buttonStyle = {
        padding: "10px 15px",
        backgroundColor: showtime ? "#4CAF50" : "#1E90FF",
        color: "white",
        border: "none",
        borderRadius: "6px",
        cursor: "pointer",
        fontWeight: "bold",
    };
    const formContainerStyle = {
        maxWidth: "500px",
        margin: "20px auto",
        padding: "20px",
        border: "1px solid #ddd",
        borderRadius: "10px",
        boxShadow: "0 2px 8px rgba(0,0,0,0.1)",
        backgroundColor: "#fff",
    };

    return (
        <div style={formContainerStyle}>
            <h2 style={{ textAlign: "center", marginBottom: "20px" }}>
                {showtime ? "Edit" : "Add"} Showtime
            </h2>
            <form onSubmit={handleSubmit}>
                <div style={formGroupStyle}>
                    <label style={labelStyle}>Movie:</label>
                    <select style={inputStyle} value={movieId} onChange={(e) => setMovieId(e.target.value)} required>
                        <option value="">Select Movie</option>
                        {movies.map((movie) => (
                            <option key={movie.id} value={movie.id}>
                                {movie.title}
                            </option>
                        ))}
                    </select>
                </div>
                <div style={formGroupStyle}>
                    <label style={labelStyle}>Screen:</label>
                    <select style={inputStyle} value={screenId} onChange={(e) => setScreenId(e.target.value)} required>
                        <option value="">Select Screen</option>
                        {screens.map((screen) => (
                            <option key={screen.id} value={screen.id}>
                                {screen.name}
                            </option>
                        ))}
                    </select>
                </div>
                <div style={formGroupStyle}>
                    <label style={labelStyle}>Start Time:</label>
                    <input style={inputStyle} type="datetime-local" value={startTime} onChange={(e) => setStartTime(e.target.value)} required />
                </div>
                <div style={formGroupStyle}>
                    <label style={labelStyle}>End Time:</label>
                    <input style={inputStyle} type="datetime-local" value={endTime} onChange={(e) => setEndTime(e.target.value)} required />
                </div>
                <div style={formGroupStyle}>
                    <label style={labelStyle}>Language:</label>
                    <input style={inputStyle} type="text" value={language} onChange={(e) => setLanguage(e.target.value)} required />
                </div>
                <div style={formGroupStyle}>
                    <label style={labelStyle}>Available Seats:</label>
                    <input
                        style={inputStyle}
                        type="number"
                        value={availableSeats}
                        onChange={(e) => setAvailableSeats(e.target.value)}
                        required
                    />
                </div>
                <button style={buttonStyle} type="submit">
                    {showtime ? "Update" : "Create"} Showtime
                </button>
            </form>
        </div>
    );
};

export default ShowtimeForm;
