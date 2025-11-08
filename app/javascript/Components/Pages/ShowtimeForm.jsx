import React, { useState, useEffect } from "react";
import axios from "axios";

const ShowtimeForm = ({ showtime = null, onSuccess }) => {
    const token = localStorage.getItem("token");

    const formatDateTimeLocal = (isoString) => {
        if (!isoString) return "";
        const date = new Date(isoString);
        const offset = date.getTimezoneOffset();
        const localDate = new Date(date.getTime() - offset * 60000);
        return localDate.toISOString().slice(0, 16);
    };

    const [movieId, setMovieId] = useState(showtime?.movie_id || "");
    const [screenId, setScreenId] = useState(showtime?.screen_id || "");
    const [startTime, setStartTime] = useState(formatDateTimeLocal(showtime?.start_time));
    const [endTime, setEndTime] = useState(formatDateTimeLocal(showtime?.end_time));
    const [language, setLanguage] = useState(showtime?.language || "");
    const [availableSeats, setAvailableSeats] = useState(showtime?.available_seats || 0);
    const [movies, setMovies] = useState([]);
    const [screens, setScreens] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const [moviesRes, screensRes] = await Promise.all([
                    axios.get("http://localhost:3000/api/movies", {
                        headers: { Authorization: `Bearer ${token}` },
                    }),
                    axios.get("http://localhost:3000/screens", {
                        headers: { Authorization: `Bearer ${token}` },
                    }),
                ]);
                setMovies(Array.isArray(moviesRes.data) ? moviesRes.data : []);
                setScreens(Array.isArray(screensRes.data) ? screensRes.data : []);
            } catch (err) {
                console.error("Error fetching data:", err);
            }
        };
        fetchData();
    }, [token]);

    const handleSubmit = async (e) => {
        e.preventDefault();

        const data = {
            showtime: {
                movie_id: parseInt(movieId),
                screen_id: parseInt(screenId),
                start_time: new Date(startTime).toISOString(),
                end_time: new Date(endTime).toISOString(),
                language,
                available_seats: parseInt(availableSeats),
            },
        };

        const url = showtime
            ? `/showtimes/${showtime.id}`
            : "/showtimes";
        const method = showtime ? "patch" : "post";

        try {
            const res = await axios({
                method,
                url,
                headers: {
                    Authorization: `Bearer ${token}`,
                    "Content-Type": "application/json",
                },
                data,
            });
            alert(`Showtime ${showtime ? "updated" : "created"} successfully!`);
            if (onSuccess) onSuccess(res.data);
        } catch (err) {
            console.error("Error saving showtime:", err);
            alert("Error saving showtime. Please check your inputs or server.");
        }
    };

    const formGroup = { display: "flex", flexDirection: "column", marginBottom: "15px" };
    const label = { marginBottom: "5px", fontWeight: "bold" };
    const input = {
        padding: "8px 10px",
        borderRadius: "6px",
        border: "1px solid #ccc",
        fontSize: "14px",
    };
    const button = {
        padding: "10px 15px",
        backgroundColor: showtime ? "#4CAF50" : "#1E90FF",
        color: "white",
        border: "none",
        borderRadius: "6px",
        cursor: "pointer",
        fontWeight: "bold",
        transition: "0.3s",
    };
    const container = {
        maxWidth: "500px",
        margin: "30px auto",
        padding: "25px",
        border: "1px solid #ddd",
        borderRadius: "10px",
        boxShadow: "0 4px 12px rgba(0,0,0,0.1)",
        backgroundColor: "#fff",
    };
    const heading = { textAlign: "center", marginBottom: "20px", color: "#333" };

    return (
        <div style={container}>
            <h2 style={heading}>{showtime ? "Edit Showtime" : "Add Showtime"}</h2>
            <form onSubmit={handleSubmit}>
                {/* Movie selection */}
                <div style={formGroup}>
                    <label style={label}>Movie:</label>
                    <select
                        style={input}
                        value={movieId}
                        onChange={(e) => setMovieId(e.target.value)}
                        required
                    >
                        <option value="">Select Movie</option>
                        {movies.map((movie) => (
                            <option key={movie.id} value={movie.id}>
                                {movie.title}
                            </option>
                        ))}
                    </select>
                </div>

                <div style={formGroup}>
                    <label style={label}>Screen:</label>
                    <select
                        style={input}
                        value={screenId}
                        onChange={(e) => setScreenId(e.target.value)}
                        required
                    >
                        <option value="">Select Screen</option>
                        {screens.map((screen) => (
                            <option key={screen.id} value={screen.id}>
                                {screen.name}
                            </option>
                        ))}
                    </select>
                </div>

                <div style={formGroup}>
                    <label style={label}>Start Time:</label>
                    <input
                        style={input}
                        type="datetime-local"
                        value={startTime}
                        onChange={(e) => setStartTime(e.target.value)}
                        required
                    />
                </div>

                <div style={formGroup}>
                    <label style={label}>End Time:</label>
                    <input
                        style={input}
                        type="datetime-local"
                        value={endTime}
                        onChange={(e) => setEndTime(e.target.value)}
                        required
                    />
                </div>

                <div style={formGroup}>
                    <label style={label}>Language:</label>
                    <input
                        style={input}
                        type="text"
                        value={language}
                        onChange={(e) => setLanguage(e.target.value)}
                        required
                    />
                </div>

                <div style={formGroup}>
                    <label style={label}>Available Seats:</label>
                    <input
                        style={input}
                        type="number"
                        min="1"
                        value={availableSeats}
                        onChange={(e) => setAvailableSeats(e.target.value)}
                        required
                    />
                </div>

                <button style={button} type="submit">
                    {showtime ? "Update Showtime" : "Create Showtime"}
                </button>
            </form>
        </div>
    );
};

export default ShowtimeForm;
