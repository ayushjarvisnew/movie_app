import React, { useState, useEffect, useRef } from "react";
import axios from "axios";
import MovieForm from "./MovieForm";
import TheatreForm from "./TheatreForm";
import ScreenForm from "./ScreenForm";
import ShowtimeForm from "./ShowtimeForm";

const Admin = () => {
    const [tab, setTab] = useState("users");
    const [users, setUsers] = useState([]);
    const [movies, setMovies] = useState([]);
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

    // fetching function here
    const fetchUsers = () => {
        axios.get("http://localhost:3000/users", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setUsers(res.data))
            .catch(err => console.error(err));
    };

    const fetchMovies = () => {
        axios.get("http://localhost:3000/api/movies", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setMovies(res.data))
            .catch(err => console.error(err));
    };

    const fetchTheatres = () => {
        axios.get("http://localhost:3000/theatres", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setTheatres(res.data))
            .catch(err => console.error(err));
    };

    const fetchScreens = () => {
        axios.get("http://localhost:3000/screens", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setScreens(res.data))
            .catch(err => console.error(err));
    };

    const fetchShowtimes = () => {
        axios.get("http://localhost:3000/showtimes", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setShowtimes(res.data))
            .catch(err => console.error(err));
    };

    // Delete / Promote / Demote
    const deleteUser = (id) => {
        if (!window.confirm("Delete this user?")) return;
        axios.delete(`http://localhost:3000/users/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchUsers)
            .catch(err => console.error(err));
    };

    const promoteToAdmin = (user) => {
        if (!window.confirm(`Promote ${user.name} to Admin?`)) return;
        axios.patch(`http://localhost:3000/users/${user.id}`, { user: { is_admin: true } }, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchUsers)
            .catch(err => console.error(err));
    };

    const demoteFromAdmin = (user) => {
        if (!window.confirm(`Remove Admin rights from ${user.name}?`)) return;
        axios.patch(`http://localhost:3000/users/${user.id}`, { user: { is_admin: false } }, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchUsers)
            .catch(err => console.error(err));
    };

    const deleteMovie = (id) => {
        if (!window.confirm("Delete this movie?")) return;
        axios.delete(`http://localhost:3000/api/movies/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchMovies)
            .catch(err => console.error(err));
    };

    const deleteTheatre = (id) => {
        if (!window.confirm("Delete this theatre?")) return;
        axios.delete(`http://localhost:3000/theatres/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchTheatres)
            .catch(err => console.error(err));
    };

    const deleteScreen = (id) => {
        if (!window.confirm("Delete this screen?")) return;
        axios.delete(`http://localhost:3000/screens/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchScreens)
            .catch(err => console.error(err));
    };

    const deleteShowtime = (id) => {
        if (!window.confirm("Delete this showtime?")) return;
        axios.delete(`http://localhost:3000/showtimes/${id}`, { headers: { Authorization: `Bearer ${token}` } })
            .then(fetchShowtimes)
            .catch(err => console.error(err));
    };

    // Handle edit with scroll
    const handleEditMovie = (movie) => {
        setEditingMovie(movie);
        if (movieFormRef.current) movieFormRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    const handleEditTheatre = (theatre) => {
        setEditingTheatre(theatre);
        if (theatreFormRef.current) theatreFormRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    const handleEditScreen = (screen) => {
        setEditingScreen(screen);
        if (screenFormRef.current) screenFormRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    const handleEditShowtime = (showtime) => {
        setEditingShowtime(showtime);
        if (showtimeFormRef.current) showtimeFormRef.current.scrollIntoView({ behavior: "smooth", block: "start" });
    };

    useEffect(() => {
        fetchUsers();
        fetchMovies();
        fetchTheatres();
        fetchScreens();
        fetchShowtimes();
    }, []);

    const renderCards = (items, type) => {
        if (!Array.isArray(items) || items.length === 0)
            // if (array(array<item>)) => is not array and length=0
            return <p>No {type} available</p>;
           // if valid then
        return items.map(item => (
            <div key={item.id} style={{ border: "1px solid #ccc", borderRadius: "8px", padding: "15px", boxShadow: "0 1px 4px rgba(0,0,0,0.1)" }}>
                <h3 style={{ marginBottom: "10px" }}>{item.title || item.name || `Showtime #${item.id}`}</h3>

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
                        <p><strong>Rating:</strong> {item.rating}</p>
                    </>
                )}

                {type === "screens" && (
                    <>
                        <p><strong>Seats:</strong> {item.seats || "N/A"}</p>
                        <p><strong>Type:</strong> {item.screen_type || "Standard"}</p>
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

                <div style={{ display: "flex", justifyContent: "center", gap: "10px", marginTop: "10px" }}>
                    {type === "users" && (
                        <>
                            {!item.is_admin && (
                                <button onClick={() => promoteToAdmin(item)} style={{ padding: "5px 10px", backgroundColor: "green", color: "white", border: "none", borderRadius: "4px" }}>Make Admin</button>
                            )}
                            {item.is_admin && (
                                <button onClick={() => demoteFromAdmin(item)} style={{ padding: "5px 10px", backgroundColor: "orange", color: "white", border: "none", borderRadius: "4px" }}>Remove Admin</button>
                            )}
                            <button onClick={() => deleteUser(item.id)} style={{ padding: "5px 10px", backgroundColor: "red", color: "white", border: "none", borderRadius: "4px" }}>Delete</button>
                        </>
                    )}

                    {type === "movies" && (
                        <>
                            <button onClick={() => handleEditMovie(item)} style={{ padding: "5px 10px", backgroundColor: "green", color: "white", border: "none", borderRadius: "4px" }}>Edit</button>
                            <button onClick={() => deleteMovie(item.id)} style={{ padding: "5px 10px", backgroundColor: "red", color: "white", border: "none", borderRadius: "4px" }}>Delete</button>
                        </>
                    )}

                    {type === "theatres" && (
                        <>
                            <button onClick={() => handleEditTheatre(item)} style={{ padding: "5px 10px", backgroundColor: "green", color: "white", border: "none", borderRadius: "4px" }}>Edit</button>
                            <button onClick={() => deleteTheatre(item.id)} style={{ padding: "5px 10px", backgroundColor: "red", color: "white", border: "none", borderRadius: "4px" }}>Delete</button>
                        </>
                    )}

                    {type === "screens" && (
                        <>
                            <button onClick={() => handleEditScreen(item)} style={{ padding: "5px 10px", backgroundColor: "green", color: "white", border: "none", borderRadius: "4px" }}>Edit</button>
                            <button onClick={() => deleteScreen(item.id)} style={{ padding: "5px 10px", backgroundColor: "red", color: "white", border: "none", borderRadius: "4px" }}>Delete</button>
                        </>
                    )}

                    {type === "showtimes" && (
                        <>
                            <button onClick={() => handleEditShowtime(item)} style={{ padding: "5px 10px", backgroundColor: "green", color: "white", border: "none", borderRadius: "4px" }}>Edit</button>
                            <button onClick={() => deleteShowtime(item.id)} style={{ padding: "5px 10px", backgroundColor: "red", color: "white", border: "none", borderRadius: "4px" }}>Delete</button>
                        </>
                    )}
                </div>
            </div>
        ));
    };

    return (
        <div style={{ maxWidth: "900px", margin: "0 auto", padding: "20px" }}>
            <h1 style={{ textAlign: "center", marginBottom: "30px" }}>Admin Dashboard</h1>


            <div style={{ marginBottom: "30px" }}>
                <button onClick={() => setTab("users")} style={{ marginRight: "10px" }}>Users</button>
                <button onClick={() => setTab("movies")} style={{ marginRight: "10px" }}>Movies</button>
                <button onClick={() => setTab("theatres")} style={{ marginRight: "10px" }}>Theatres</button>
                <button onClick={() => setTab("screens")} style={{ marginRight: "10px" }}>Screens</button>
                <button onClick={() => setTab("showtimes")} style={{ marginRight: "10px" }}>Showtimes</button>
            </div>


            {tab === "users" && (
                <div>
                    <h2 style={{ marginBottom: "20px" }}>Users</h2>
                    <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))", gap: "20px" }}>
                        {renderCards(users, "users")}
                    </div>
                </div>
            )}


            {tab === "movies" && (
                <div ref={movieFormRef}>
                    <MovieForm key={editingMovie?.id || "new"} movie={editingMovie} onSuccess={() => { setEditingMovie(null); fetchMovies(); }} />
                    <h2 style={{ marginBottom: "20px" }}>Movies</h2>
                    <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))", gap: "20px" }}>
                        {renderCards(movies, "movies")}
                    </div>
                </div>
            )}


            {tab === "theatres" && (
                <div ref={theatreFormRef}>
                    <TheatreForm key={editingTheatre?.id || "new"} theatre={editingTheatre} onSuccess={() => { setEditingTheatre(null); fetchTheatres(); }} />
                    <h2 style={{ marginBottom: "20px" }}>Theatres</h2>
                    <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))", gap: "20px" }}>
                        {renderCards(theatres, "theatres")}
                    </div>
                </div>
            )}


            {tab === "screens" && (
                <div ref={screenFormRef}>
                    <ScreenForm key={editingScreen?.id || "new"} screen={editingScreen} onSuccess={() => { setEditingScreen(null); fetchScreens(); }} />
                    <h2 style={{ marginBottom: "20px" }}>Screens</h2>
                    <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))", gap: "20px" }}>
                        {renderCards(screens, "screens")}
                    </div>
                </div>
            )}


            {tab === "showtimes" && (
                <div ref={showtimeFormRef}>
                    <ShowtimeForm key={editingShowtime?.id || "new"} showtime={editingShowtime} onSuccess={() => { setEditingShowtime(null); fetchShowtimes(); }} />
                    <h2 style={{ marginBottom: "20px" }}>Showtimes</h2>
                    <div style={{ display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))", gap: "20px" }}>
                        {renderCards(showtimes, "showtimes")}
                    </div>
                </div>
            )}
        </div>
    );
};

export default Admin;
