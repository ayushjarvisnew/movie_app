import React, { useState, useEffect } from "react";
import axios from "axios";
import ShowtimeForm from "./ShowtimeForm";
import "../Css/ShowtimeList.css";

const ShowtimeList = () => {
    const [showtimes, setShowtimes] = useState([]);
    const [editingShowtime, setEditingShowtime] = useState(null);
    const token = localStorage.getItem("token");

    const fetchShowtimes = () => {
        axios
            .get("http://localhost:3000/showtimes", {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => {
                const data = Array.isArray(res.data) ? res.data : [];
                setShowtimes(data);
            })
            .catch((err) => console.error(err));
    };

    useEffect(() => {
        fetchShowtimes();
    }, []);

    const handleEdit = (showtime) => setEditingShowtime(showtime);

    const handleDelete = (id) => {
        if (!window.confirm("Are you sure?")) return;
        axios
            .delete(`http://localhost:3000/showtimes/${id}`, {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then(() => fetchShowtimes())
            .catch((err) => console.error(err));
    };

    return (
        <div className="showtime-container">
            <div className="showtime-form-section">
                <h2>{editingShowtime ? "Edit Showtime" : "Add Showtime"}</h2>
                <ShowtimeForm
                    showtime={editingShowtime}
                    onSuccess={() => {
                        setEditingShowtime(null);
                        fetchShowtimes();
                    }}
                />
            </div>

            <div className="showtime-list-section">
                <h2>Showtimes List</h2>
                <div className="table-wrapper">
                    <table className="showtime-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Movie</th>
                            <th>Screen</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Language</th>
                            <th>Available Seats</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        {showtimes.length > 0 ? (
                            showtimes.map((st) => (
                                <tr key={st.id}>
                                    <td>{st.id}</td>
                                    <td>{st.movie?.title || st.movie_id}</td>
                                    <td>{st.screen?.name || st.screen_id}</td>
                                    <td>{new Date(st.start_time).toLocaleString()}</td>
                                    <td>{new Date(st.end_time).toLocaleString()}</td>
                                    <td>{st.language}</td>
                                    <td>{st.available_seats}</td>
                                    <td>
                                        <button
                                            className="edit-btn"
                                            onClick={() => handleEdit(st)}
                                        >
                                            Edit
                                        </button>
                                        <button
                                            className="delete-btn"
                                            onClick={() => handleDelete(st.id)}
                                        >
                                            Delete
                                        </button>
                                    </td>
                                </tr>
                            ))
                        ) : (
                            <tr>
                                <td colSpan="8" style={{ textAlign: "center" }}>
                                    No showtimes available
                                </td>
                            </tr>
                        )}
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    );
};

export default ShowtimeList;
