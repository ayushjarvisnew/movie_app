import React, { useState, useEffect } from "react";
import axios from "axios";
import UserReservation from "./UserReservation";
import Slider from "react-slick";
import "slick-carousel/slick/slick.css";
import "../Css/CustomSlick.css";
import "../Css/Movie.css";
import { FaStar } from "react-icons/fa";

const Movies = () => {
    const [movies, setMovies] = useState([]);
    const [upcomingMovies, setUpcomingMovies] = useState([]);
    const [selectedMovie, setSelectedMovie] = useState(null);
    const [searchTerm, setSearchTerm] = useState("");

    useEffect(() => {
        const token = localStorage.getItem("token");

        axios
            .get("/api/movies", { headers: { Authorization: `Bearer ${token}` } })
            .then((res) => {
                if (Array.isArray(res.data)) {
                    const today = new Date();
                    setMovies(res.data.filter((m) => new Date(m.release_date) <= today));
                }
            })
            .catch((err) => console.error(err));

        axios
            .get("/api/upcoming_movies", { headers: { Authorization: `Bearer ${token}` } })
            .then((res) => Array.isArray(res.data) && setUpcomingMovies(res.data))
            .catch((err) => console.error(err));
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
        responsive: [{ breakpoint: 768, settings: { slidesToShow: 1 } }],
    };

    const renderStars = (rating) => {
        const fullStars = Math.floor(rating);
        return (
            <div className="stars">
                {Array.from({ length: 5 }, (_, i) => (
                    <FaStar key={i} color={i < fullStars ? "#FFD700" : "#555"} />
                ))}
            </div>
        );
    };

    const renderMovieCard = (movie, isUpcoming = false) => (
        <div key={movie.id} className="movie-card">
            <img src={movie.poster_image || "/default-poster.png"} alt={movie.title} />
            {!isUpcoming && (
                <div className="overlay">
                    <p>{movie.description?.slice(0, 100)}...</p>
                    {renderStars(movie.rating)}
                    <button onClick={() => setSelectedMovie(movie)}>Book Now</button>
                </div>
            )}
            <div className="movie-info">
                <h3>{movie.title}</h3>
                <div className="tags">
                    {movie.tags?.map((tag) => (
                        <span key={tag.id} className="tag">{tag.name}</span>
                    ))}
                </div>
                {isUpcoming && <button className="coming-soon" disabled>Coming Soon</button>}
            </div>
        </div>
    );

    return (
        <div className="movies-container">
            <h1>Movies 🎬</h1>

            <input
                type="text"
                placeholder="Search for a movie..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="search-input"
            />

            {/* Released Movies */}
            <div className="section">
                <h2>🎥 All Released Movies</h2>
                {filteredMovies.length > 0 ? (
                    <div className="carousel-container">
                        <Slider {...carouselSettings}>
                            {filteredMovies.map((movie) => renderMovieCard(movie))}
                        </Slider>
                    </div>
                ) : <p>No movies available</p>}
            </div>

            {/* Top Rated Movies */}
            {topRatedMovies.length > 0 && (
                <div className="section">
                    <h2>⭐ Top Rated Movies</h2>
                    <div className="carousel-container">
                        <Slider {...carouselSettings}>
                            {topRatedMovies.map((movie) => renderMovieCard(movie))}
                        </Slider>
                    </div>
                </div>
            )}

            {/* Upcoming Movies */}
            {upcomingMovies.length > 0 && (
                <div className="section">
                    <h2>🎬 Upcoming Movies</h2>
                    <div className="carousel-container">
                        <Slider {...carouselSettings}>
                            {upcomingMovies.map((movie) => renderMovieCard(movie, true))}
                        </Slider>
                    </div>
                </div>
            )}

            {/* Reservation Modal */}
            {selectedMovie && (
                <div className="modal-overlay">
                    <div className="modal-content">
                        <h2>{selectedMovie.title}</h2>
                        <p>{selectedMovie.description}</p>
                        <UserReservation movieId={selectedMovie.id} />
                        <button onClick={() => setSelectedMovie(null)}>Close</button>
                    </div>
                </div>
            )}
        </div>
    );
};

export default Movies;
