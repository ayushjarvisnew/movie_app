import React, { useState, useEffect } from "react";
import axios from "axios";
import UserReservation from "./UserReservation";
import Slider from "react-slick";
import "slick-carousel/slick/slick.css";
import "../Css/CustomSlick.css";

const Movies = () => {
    const [movies, setMovies] = useState([]);
    const [upcomingMovies, setUpcomingMovies] = useState([]);
    const [selectedMovie, setSelectedMovie] = useState(null);
    const [searchTerm, setSearchTerm] = useState("");

    useEffect(() => {
        const token = localStorage.getItem("token");


        axios
            .get("http://localhost:3000/api/movies", {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => {
                if (Array.isArray(res.data)) {

                    const today = new Date();
                    const released = res.data.filter(
                        (m) => new Date(m.release_date) <= today
                    );
                    setMovies(released);
                }
            })
            .catch((err) => console.error(err));


        axios
            .get("http://localhost:3000/api/upcoming_movies", {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => Array.isArray(res.data) && setUpcomingMovies(res.data))
            .catch((err) => console.error("Error loading upcoming movies:", err));
    }, []);

    const filteredMovies = movies.filter((movie) =>
        movie.title.toLowerCase().includes(searchTerm.toLowerCase())
    );

    const topRatedMovies = movies.filter((m) => m.rating >= 4.0);

    const carouselSettings = {
        dots: true,
        infinite: true,
        slidesToShow: 4,
        slidesToScroll: 1,
        autoplay: true,
        autoplaySpeed: 3000,
        arrows: false,
        pauseOnHover: true,
        responsive: [
            {
                breakpoint: 768,
                settings: { slidesToShow: 1 },
            },
        ],
    };

    return (
        <div style={{ textAlign: "center", padding: "20px" }}>
            <h1>Movies</h1>

            <input
                type="text"
                placeholder="Search for a movie..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                style={{
                    padding: "10px",
                    marginBottom: "20px",
                    width: "300px",
                    borderRadius: "5px",
                    border: "1px solid #ccc",
                }}
            />



            <div style={{ marginTop: "40px" }}>
                <h2>🎥 All Released Movies</h2>
                {filteredMovies.length > 0 ? (
                    <div style={{ width: "80%", margin: "auto" }}>
                        <Slider {...carouselSettings}>
                            {filteredMovies.map((movie) => (
                                <div
                                    key={movie.id}
                                    style={{
                                        border: "1px solid #ccc",
                                        borderRadius: "8px",
                                        padding: "10px",
                                        width: "220px",
                                        margin: "auto",
                                        boxShadow: "0 2px 5px rgba(0,0,0,0.2)",
                                        textAlign: "center",
                                        backgroundColor: "#fff",
                                    }}
                                >
                                    <img
                                        src={movie.poster_image || "/default-poster.png"}
                                        alt={movie.title}
                                        style={{
                                            width: "200px",
                                            height: "250px",
                                            objectFit: "cover",
                                            borderRadius: "10px",
                                            margin: "auto",
                                        }}
                                    />
                                    <h3 style={{ marginTop: "10px" }}>{movie.title}</h3>
                                    <p>
                                        Tags:{" "}
                                        {movie.tags?.length
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
                                            marginTop: "10px",
                                        }}
                                        onClick={() => setSelectedMovie(movie)}
                                    >
                                        Book Ticket
                                    </button>
                                </div>
                            ))}
                        </Slider>
                    </div>
                ) : (
                    <p>No movies available</p>
                )}
            </div>

            {topRatedMovies.length > 0 && (
                <div style={{ marginTop: "30px" }}>
                    <h2>⭐ Top Rated Movies</h2>
                    <div style={{ width: "90%", margin: "auto" }}>
                        <Slider {...carouselSettings}>
                            {topRatedMovies.map((movie) => (
                                <div key={movie.id}>
                                    <img
                                        src={movie.poster_image || "/default-poster.png"}
                                        alt={movie.title}
                                        style={{
                                            width: "200px",
                                            height: "250px",
                                            objectFit: "cover",
                                            margin: "auto",
                                            borderRadius: "10px",
                                        }}
                                    />
                                    <h4 style={{ marginTop: "10px" }}>{movie.title}</h4>
                                    <p>Rating: {movie.rating}</p>
                                </div>
                            ))}
                        </Slider>
                    </div>
                </div>
            )}

            <div style={{ marginTop: "50px" }}>
                <h2>🎬 Upcoming Movies</h2>
                {upcomingMovies.length > 0 ? (
                    <div style={{ width: "80%", margin: "auto" }}>
                        <Slider {...carouselSettings}>
                            {upcomingMovies.map((movie) => (
                                <div
                                    key={movie.id}
                                    style={{
                                        border: "1px solid #ddd",
                                        borderRadius: "8px",
                                        padding: "2px",
                                        textAlign: "center",
                                        boxShadow: "0 3px 6px rgba(0,0,0,0.1)",
                                        backgroundColor: "#fafafa",
                                    }}
                                >
                                    <img
                                        src={movie.poster_image || "/default-poster.png"}
                                        alt={movie.title}
                                        style={{
                                            width: "220px",
                                            height: "300px",
                                            objectFit: "cover",
                                            borderRadius: "10px",
                                            margin: "auto",
                                        }}
                                    />
                                    <h4 style={{ marginTop: "10px" }}>{movie.title}</h4>
                                    <p style={{ color: "#666" }}>
                                        Releasing on {movie.release_date}
                                    </p>
                                    <button
                                        disabled
                                        style={{
                                            padding: "8px 12px",
                                            borderRadius: "6px",
                                            backgroundColor: "#888",
                                            color: "#fff",
                                            border: "none",
                                            cursor: "not-allowed",
                                            opacity: 0.8,
                                        }}
                                    >
                                         Comming Soon
                                    </button>
                                </div>
                            ))}
                        </Slider>
                    </div>
                ) : (
                    <p>No upcoming movies</p>
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
                        <UserReservation movieId={selectedMovie.id} />
                        <button
                            onClick={() => setSelectedMovie(null)}
                            style={{
                                marginTop: "10px",
                                padding: "6px 12px",
                                borderRadius: "5px",
                                border: "1px solid #ccc",
                                cursor: "pointer",
                            }}
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

