import React, { useEffect, useState } from "react";
import axios from "axios";

const ShowtimeSelector = ({ movie, onSelectShowtime }) => {
    const [showtimes, setShowtimes] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState(null);

    useEffect(() => {
        if (!movie) return;
        const token = localStorage.getItem("token");
        setLoading(true);
        setError(null);

        axios.get(`http://localhost:3000/api/movies/${movie.id}/showtimes`, {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => {
                const data = Array.isArray(res.data) ? res.data : [];
                setShowtimes(data);
            })
            .catch((err) => {
                console.error(err);
                setError("Please login or signup first to book tickets.");
            })
            .finally(() => setLoading(false));
    }, [movie]);

    if (loading) return <p>Loading showtimes...</p>;
    if (error) return <p style={{ color: "red" }}>{error}</p>;
    if (!showtimes.length) return <p>No showtimes available for this movie.</p>;

    return (
        <div>
            <h4>Select Showtime:</h4>
            <div style={{ display: "flex", flexWrap: "wrap", gap: "8px" }}>
                {showtimes.map((show) => (
                    <button
                        key={show.id}
                        onClick={() => onSelectShowtime(show)}
                        style={{
                            padding: "8px 12px",
                            borderRadius: "6px",
                            border: "1px solid #1e90ff",
                            backgroundColor: "#1e90ff",
                            color: "#fff",
                            cursor: "pointer",
                        }}
                    >
                        {new Date(show.start_time).toLocaleString("en-GB", {
                            day: "2-digit",
                            month: "short",
                            year: "numeric",
                            hour: "2-digit",
                            minute: "2-digit",
                        })}
                    </button>
                ))}
            </div>
        </div>
    );
};

export default ShowtimeSelector;
