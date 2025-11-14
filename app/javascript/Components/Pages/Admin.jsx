import React, { useState, useEffect, useRef } from "react";
import axios from "axios";
import MovieForm from "./MovieForm";
import TheatreForm from "./TheatreForm";
import ScreenForm from "./ScreenForm";
import ShowtimeForm from "./ShowtimeForm";
import "../Css/Admin.css";

const Admin = () => {
    const [tab, setTab] = useState("users");
    const [users, setUsers] = useState([]);
    const [movies, setMovies] = useState([]);
    const [upcomingMovies, setUpcomingMovies] = useState([]); // 🆕 Added
    const [editingMovie, setEditingMovie] = useState(null);
    const [theatres, setTheatres] = useState([]);
    const [editingTheatre, setEditingTheatre] = useState(null);
    const [screens, setScreens] = useState([]);
    const [editingScreen, setEditingScreen] = useState(null);
    const [showtimes, setShowtimes] = useState([]);
    const [editingShowtime, setEditingShowtime] = useState(null);

    const token = localStorage.getItem("token");

    const movieFormRef = useRef(null);
    const theatreFormRef = useRef(null);
    const screenFormRef = useRef(null);
    const showtimeFormRef = useRef(null);


    const fetchUsers = () => {
        axios
            .get("/users", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setUsers(res.data))
            .catch(err => console.error(err));
    };

    const fetchMovies = () => {
        axios
            .get("/api/movies", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setMovies(res.data))
            .catch(err => console.error(err));
    };


    const fetchUpcomingMovies = () => {
        axios
            .get("/api/upcoming_movies", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setUpcomingMovies(res.data))
            .catch(err => console.error(err));
    };

    const fetchTheatres = () => {
        axios
            .get("/theatres", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setTheatres(res.data))
            .catch(err => console.error(err));
    };

    const fetchScreens = () => {
        axios
            .get("/screens", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setScreens(res.data))
            .catch(err => console.error(err));
    };

    const fetchShowtimes = () => {
        axios
            .get("/showtimes", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setShowtimes(res.data))
            .catch(err => console.error(err));
    };


    const deleteUser = id => {
        if (!window.confirm("Delete this user?")) return;
        axios
            .delete(`/users/${id}`, {
             headers: { Authorization: `Bearer ${token}` } })
            .then(() => {
                fetchUsers();
                alert("User deleted successfully!");
            })
            .catch((err) => {
                const message = err.response?.data?.error || "Failed to delete user.";
                alert(message);
                console.error(err);
            });
    };

    const promoteToAdmin = user => {
        if (!window.confirm(`Promote ${user.name} to Admin?`)) return;
        axios
            .patch(
                `/users/${user.id}`,
                { user: { is_admin: true } },
                { headers: { Authorization: `Bearer ${token}` } }
            )
            .then(fetchUsers)
            .catch(err => console.error(err));
    };

    const demoteFromAdmin = user => {
        if (!window.confirm(`Remove Admin rights from ${user.name}?`)) return;
        axios
            .patch(
                `/users/${user.id}`,
                { user: { is_admin: false } },
                { headers: { Authorization: `Bearer ${token}` } }
            )
            .then(fetchUsers)
            .catch(err => console.error(err));
    };

    const deleteMovie = id => {
        if (!window.confirm("Delete this movie?")) return;
        axios
            .delete(`/api/movies/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(() => {
                fetchMovies();
                fetchUpcomingMovies();
                alert("Movie deleted successfully!");
            })
            .catch((err) => {
                const message = err.response?.data?.error || "Failed to delete movie.";
                alert(message);
            });
    };

    const deleteTheatre = id => {
        if (!window.confirm("Delete this theatre?")) return;
        axios
            .delete(`/theatres/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchTheatres)
            .catch(err => console.error(err));
    };

    const deleteScreen = id => {
        if (!window.confirm("Delete this screen?")) return;
        axios
            .delete(`/screens/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchScreens)
            .catch(err => console.error(err));
    };

    const deleteShowtime = id => {
        if (!window.confirm("Delete this showtime?")) return;
        axios
            .delete(`/showtimes/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchShowtimes)
            .catch(err => console.error(err));
    };


    const handleEditMovie = movie => {
        setEditingMovie(movie);
        movieFormRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    const handleCancelEditMovie = () => {
        setEditingMovie(null);
        movieFormRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    const handleEditTheatre = theatre => {
        setEditingTheatre(theatre);
        theatreFormRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    const handleEditScreen = screen => {
        setEditingScreen(screen);
        screenFormRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    const handleEditShowtime = showtime => {
        const formattedShowtime = {
            ...showtime,
            movie_id: showtime.movie?.id || showtime.movie_id,
            screen_id: showtime.screen?.id || showtime.screen_id,
            start_time: showtime.start_time,
            end_time: showtime.end_time,
        };
        setEditingShowtime(formattedShowtime);
        showtimeFormRef.current?.scrollIntoView({ behavior: "smooth", block: "start" });
    };


    useEffect(() => {
        fetchUsers();
        fetchMovies();
        fetchUpcomingMovies();
        fetchTheatres();
        fetchScreens();
        fetchShowtimes();
    }, []);


    const renderCards = (items, type) => {
        if (!Array.isArray(items) || items.length === 0) {
            return <p className="empty-text">No {type} available</p>;
        }

        return items.map(item => (
            <div key={item.id} className="admin-card">
                <h3>{item.title || item.name || `Showtime #${item.id}`}</h3>

                {type === "users" && (
                    <>
                        <p><strong>Email:</strong> {item.email}</p>
                        <p><strong>Role:</strong> {item.is_admin ? "Admin" : "User"}</p>
                    </>
                )}

                {type === "movies" && (
                    <>
                        <p><strong>Release:</strong> {item.release_date}</p>
                        <p><strong>Rating:</strong> {item.rating}</p>
                        <p><strong>Tags:</strong> {Array.isArray(item.tags) ? item.tags.map(t => t.name).join(", ") : "No tags"}</p>
                    </>
                )}

                {type === "theatres" && (
                    <>
                        <p><strong>Address:</strong> {item.address}</p>
                        <p><strong>City:</strong> {item.city}, <strong>State:</strong> {item.state}</p>
                        <p><strong>Country:</strong> {item.country}</p>
                    </>
                )}

                {type === "screens" && (
                    <>
                        <p><strong>Seats:</strong> {item.seats || "N/A"}</p>
                        <p><strong>Theatre:</strong> {item.theatre?.name || "N/A"}</p>
                    </>
                )}

                {type === "showtimes" && (
                    <>
                        <p><strong>Movie:</strong> {item.movie?.title}</p>
                        <p><strong>Screen:</strong> {item.screen?.name}</p>
                        <p><strong>Start:</strong> {item.start_time}</p>
                        <p><strong>End:</strong> {item.end_time}</p>
                        <p><strong>Language:</strong> {item.language}</p>
                        <p><strong>Available Seats:</strong> {item.available_seats}</p>
                    </>
                )}

                <div className="admin-card-buttons">
                    {type === "users" && (
                        <>
                            {!item.is_admin && <button onClick={() => promoteToAdmin(item)} className="btn-green">Make Admin</button>}
                            {item.is_admin && <button onClick={() => demoteFromAdmin(item)} className="btn-orange">Remove Admin</button>}
                            <button onClick={() => deleteUser(item.id)} className="btn-red">Delete</button>
                        </>
                    )}

                    {type === "movies" && (
                        <>
                            <button onClick={() => handleEditMovie(item)} className="btn-green">Edit</button>
                            <button onClick={() => deleteMovie(item.id)} className="btn-red">Delete</button>
                        </>
                    )}

                    {type === "theatres" && (
                        <>
                            <button onClick={() => handleEditTheatre(item)} className="btn-green">Edit</button>
                            <button onClick={() => deleteTheatre(item.id)} className="btn-red">Delete</button>
                        </>
                    )}

                    {type === "screens" && (
                        <>
                            <button onClick={() => handleEditScreen(item)} className="btn-green">Edit</button>
                            <button onClick={() => deleteScreen(item.id)} className="btn-red">Delete</button>
                        </>
                    )}

                    {type === "showtimes" && (
                        <>
                            <button onClick={() => handleEditShowtime(item)} className="btn-green">Edit</button>
                            <button onClick={() => deleteShowtime(item.id)} className="btn-red">Delete</button>
                        </>
                    )}
                </div>
            </div>
        ));
    };

    return (
        <div className="admin-container">
            <h1 className="admin-title">Admin Dashboard</h1>

            <div className="admin-tabs">
                {["users", "movies", "theatres", "screens", "showtimes"].map(tabName => (
                    <button
                        key={tabName}
                        className={tab === tabName ? "active" : ""}
                        onClick={() => setTab(tabName)}
                    >
                        {tabName.charAt(0).toUpperCase() + tabName.slice(1)}
                    </button>
                ))}
            </div>

            {tab === "users" && (
                <div className="admin-section">
                    <h2>Users</h2>
                    <div className="cards-grid">{renderCards(users, "users")}</div>
                </div>
            )}

            {tab === "movies" && (
                <div ref={movieFormRef} className="admin-section">
                    <MovieForm
                        key={editingMovie?.id || "new"}
                        movie={editingMovie}
                        onSuccess={() => {
                            setEditingMovie(null);
                            fetchMovies();
                            fetchUpcomingMovies();
                        }}
                        onCancel={() => setEditingMovie(null)}
                    />
                    <h2>Active Movies</h2>
                    <div className="cards-grid">{renderCards(movies, "movies")}</div>


                    <h2 className="mt-4">Upcoming Movies</h2>
                    <div className="cards-grid">{renderCards(upcomingMovies, "movies")}</div>
                </div>
            )}

            {tab === "theatres" && (
                <div ref={theatreFormRef} className="admin-section">
                    <TheatreForm
                        key={editingTheatre?.id || "new"}
                        theatre={editingTheatre}
                        onSuccess={() => { setEditingTheatre(null); fetchTheatres(); }}
                        onCancel={() => setEditingTheatre(null)}
                    />
                    <h2>Theatres</h2>
                    <div className="cards-grid">{renderCards(theatres, "theatres")}</div>
                </div>
            )}

            {tab === "screens" && (
                <div ref={screenFormRef} className="admin-section">
                    <ScreenForm
                        key={editingScreen?.id || "new"}
                        screen={editingScreen}
                        onSuccess={() => { setEditingScreen(null); fetchScreens(); }}
                        onCancel={() => setEditingScreen(null)}
                    />
                    <h2>Screens</h2>
                    <div className="cards-grid">{renderCards(screens, "screens")}</div>
                </div>
            )}

            {tab === "showtimes" && (
                <div ref={showtimeFormRef} className="admin-section">
                    <ShowtimeForm
                        key={editingShowtime?.id || "new"}
                        showtime={editingShowtime}
                        onSuccess={() => { setEditingShowtime(null); fetchShowtimes(); }}
                        onCancel={() => setEditingShowtime(null)}
                    />
                    <h2>Showtimes</h2>
                    <div className="cards-grid">{renderCards(showtimes, "showtimes")}</div>
                </div>
            )}
        </div>
    );
};

export default Admin;
