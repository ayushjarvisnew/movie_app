import React, { useState, useEffect } from "react";
import axios from "axios";
import UserReservation from "./UserReservation";

const Movies = () => {
    const [movies, setMovies] = useState([]);
    const [selectedMovie, setSelectedMovie] = useState(null);

    useEffect(() => {
        const token = localStorage.getItem("token");
        axios
            .get("http://localhost:3000/api/movies", {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => setMovies(res.data))
            .catch((err) => console.error(err));
    }, []);

    return (
        <div style={{ textAlign: "center", padding: "20px" }}>
            <h1>Movies</h1>
            <div
                style={{
                    display: "flex",
                    flexWrap: "wrap",
                    justifyContent: "center",
                    gap: "20px",
                }}
            >
                {movies.length > 0 ? (
                    movies.map((movie) => (
                        <div
                            key={movie.id}
                            style={{
                                border: "1px solid #ccc",
                                borderRadius: "8px",
                                padding: "10px",
                                width: "200px",
                                boxShadow: "0 2px 5px rgba(0,0,0,0.2)",
                            }}
                        >
                            <img
                                src={movie.poster_image || "/default-poster.png"}
                                alt={movie.title}
                                style={{
                                    width: "100%",
                                    height: "250px",
                                    objectFit: "cover",
                                    borderRadius: "5px",
                                }}
                            />
                            <h3>{movie.title}</h3>
                            <p>
                                Tags:{" "}
                                {movie.tags && movie.tags.length > 0
                                    ? movie.tags.map((t) => t.name).join(", ")
                                    : "No tags"}
                            </p>
                            <p>Rating: {movie.rating}</p>
                            <p>Release: {movie.release_date}</p>
                            <button
                                style={{
                                    padding: "8px 12px",
                                    borderRadius: "6px",
                                    backgroundColor: "#1E90FF",
                                    color: "#fff",
                                    border: "none",
                                    cursor: "pointer",
                                }}
                                onClick={() => setSelectedMovie(movie)}
                            >
                                Book Ticket
                            </button>
                        </div>
                    ))
                ) : (
                    <p>No movies available</p>
                )}
            </div>

            {selectedMovie && (
                <div
                    style={{
                        position: "fixed",
                        top: 0,
                        left: 0,
                        width: "100%",
                        height: "100%",
                        backgroundColor: "rgba(0,0,0,0.5)",
                        display: "flex",
                        justifyContent: "center",
                        alignItems: "center",
                        zIndex: 1000,
                    }}
                >
                    <div
                        style={{
                            backgroundColor: "#fff",
                            padding: "20px",
                            borderRadius: "8px",
                            width: "600px",
                            maxHeight: "90vh",
                            overflowY: "auto",
                        }}
                    >
                        <h2>{selectedMovie.title}</h2>
                        <p>{selectedMovie.description}</p>

                        {/* ✅ Reservation component for selected movie */}
                        <UserReservation movieId={selectedMovie.id} />

                        <button
                            style={{
                                marginTop: "10px",
                                padding: "6px 12px",
                                borderRadius: "5px",
                                border: "1px solid #ccc",
                                cursor: "pointer",
                            }}
                            onClick={() => setSelectedMovie(null)}
                        >
                            Close
                        </button>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Movies;
