import React, { useState, useEffect } from "react";
import axios from "axios";
import "../Css/Showtime.css"; // ✅ External CSS

const ShowtimeForm = ({ showtime = null, onSuccess, onCancel }) => { // 🔹 Added onCancel prop
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
                    axios.get("/api/movies", {
                        headers: { Authorization: `Bearer ${token}` },
                    }),
                    axios.get("/screens", {
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

        const url = showtime ? `/showtimes/${showtime.id}` : "/showtimes";
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

    return (
        <div className="showtime-form-section">
            <h2>{showtime ? "Edit Showtime" : "Add Showtime"}</h2>

            <form className="showtime-form" onSubmit={handleSubmit}>
                <div className="form-group">
                    <label>Movie:</label>
                    <select
                        className="showtime-input"
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

                <div className="form-group">
                    <label>Screen:</label>
                    <select
                        className="showtime-input"
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

                <div className="form-group">
                    <label>Start Time:</label>
                    <input
                        className="showtime-input"
                        type="datetime-local"
                        value={startTime}
                        onChange={(e) => setStartTime(e.target.value)}
                        required
                    />
                </div>

                <div className="form-group">
                    <label>End Time:</label>
                    <input
                        className="showtime-input"
                        type="datetime-local"
                        value={endTime}
                        onChange={(e) => setEndTime(e.target.value)}
                        required
                    />
                </div>

                <div className="form-group">
                    <label>Language:</label>
                    <input
                        className="showtime-input"
                        type="text"
                        value={language}
                        onChange={(e) => setLanguage(e.target.value)}
                        required
                    />
                </div>

                <div className="showtime-buttons">
                    <button className="showtime-btn" type="submit">
                        {showtime ? "Update Showtime" : "Create Showtime"}
                    </button>

                    {showtime && (
                        <button
                            type="button"
                            className="cancel-btn"
                            onClick={onCancel}
                        >
                            Cancel
                        </button>
                    )}
                </div>
            </form>
        </div>
    );
};

export default ShowtimeForm;
