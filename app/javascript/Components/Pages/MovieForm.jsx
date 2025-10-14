import React, { useState, useEffect } from "react";
import axios from "axios";

const MovieForm = ({ movie = null, onSuccess }) => {
    const [title, setTitle] = useState("");
    const [description, setDescription] = useState("");
    const [posterImage, setPosterImage] = useState("");
    const [releaseDate, setReleaseDate] = useState("");
    const [duration, setDuration] = useState("");
    const [rating, setRating] = useState(0);

    const [tagOptions, setTagOptions] = useState([]);
    const [selectedTags, setSelectedTags] = useState([]);
    const [newTagInput, setNewTagInput] = useState("");
    const [newTags, setNewTags] = useState([]);
    const [successMessage, setSuccessMessage] = useState("");

    const token = localStorage.getItem("token");


    useEffect(() => {
        if (movie) {
            setTitle(movie.title || "");
            setDescription(movie.description || "");
            setPosterImage(movie.poster_image || "");
            setReleaseDate(movie.release_date || "");
            setDuration(movie.duration || "");
            setRating(movie.rating || 0);
            setSelectedTags(movie.tags?.map(t => t.id) || []);
            setNewTags([]);
            setNewTagInput("");
        } else {
            resetForm();
        }
    }, [movie]);


    useEffect(() => {
        axios.get("http://localhost:3000/tags", { headers: { Authorization: `Bearer ${token}` } })
            .then(res => setTagOptions(res.data))
            .catch(err => console.error("Error fetching tags:", err));
    }, [token]);

    const handleTagChange = (id) => {
        setSelectedTags(prev => prev.includes(id) ? prev.filter(t => t !== id) : [...prev, id]);
    };

    const handleAddNewTag = () => {
        const trimmed = newTagInput.trim();
        if (trimmed && !newTags.includes(trimmed)) {
            setNewTags([...newTags, trimmed]);
            setNewTagInput("");
        }
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        const payload = {title, description, poster_image: posterImage, release_date: releaseDate, duration, rating, tag_ids: selectedTags, new_tags: newTags};
        const url = movie ? `http://localhost:3000/api/movies/${movie.id}` : "http://localhost:3000/api/movies";
        const method = movie ? "patch" : "post";

        axios({ method, url, data: { movie: payload }, headers: { Authorization: `Bearer ${token}` } })
            .then(res => {
                setSuccessMessage("Movie saved successfully!");
                if (onSuccess) onSuccess(res.data);
                resetForm();
                setTimeout(() => setSuccessMessage(""), 3000); // hide after 3s
            })
            .catch(err => console.error("Error saving movie:", err));
    };

    const resetForm = () => {
        setTitle(""); setDescription(""); setPosterImage(""); setReleaseDate("");
        setDuration(""); setRating(0); setSelectedTags([]); setNewTags([]); setNewTagInput("");
    };

    return (
        <div style={{
            backgroundColor: "#f0f8ff",
            padding: "20px",
            borderRadius: "10px",
            boxShadow: "0 3px 10px rgba(0,0,0,0.1)",
        }}>
            <h2 style={{ textAlign: "center", marginBottom: "20px" }}>{movie ? "Edit Movie" : "Add New Movie"}</h2>

            {successMessage && (
                <div style={{
                    backgroundColor: "#d4edda",
                    color: "#155724",
                    padding: "10px",
                    borderRadius: "5px",
                    marginBottom: "10px",
                    textAlign: "center"
                }}>
                    {successMessage}
                </div>
            )}

            <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
                <input type="text" placeholder="Title" value={title} onChange={e => setTitle(e.target.value)}
                       required style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <textarea placeholder="Description" value={description} onChange={e => setDescription(e.target.value)}
                          required style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc", minHeight: "80px" }} />
                <input type="text" placeholder="Poster Image URL" value={posterImage} onChange={e => setPosterImage(e.target.value)}
                       required style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="date" value={releaseDate} onChange={e => setReleaseDate(e.target.value)}
                       required style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="number" placeholder="Duration (minutes)" value={duration} onChange={e => setDuration(e.target.value)}
                       required style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="number" step="0.1" min="0" max="5" placeholder="Rating" value={rating} onChange={e => setRating(e.target.value)}
                       style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />

                <div>
                    <label style={{ fontWeight: "bold" }}>Existing Tags:</label>
                    <div style={{ display: "flex", flexWrap: "wrap", gap: "10px", marginTop: "5px" }}>
                        {tagOptions.map(tag => (
                            <label key={tag.id} style={{ display: "flex", alignItems: "center", gap: "5px" }}>
                                <input
                                    type="checkbox"
                                    checked={selectedTags.includes(tag.id)}
                                    onChange={() => handleTagChange(tag.id)}
                                />
                                {tag.name}
                            </label>
                        ))}
                    </div>
                </div>


                <div>
                    <label style={{ fontWeight: "bold" }}>Add New Tag:</label>
                    <div style={{ display: "flex", gap: "10px", marginTop: "5px" }}>
                        <input
                            type="text"
                            placeholder="Enter new tag"
                            value={newTagInput}
                            onChange={e => setNewTagInput(e.target.value)}
                            style={{ flex: 1, padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }}
                        />
                        <button
                            type="button"
                            onClick={handleAddNewTag}
                            style={{
                                padding: "8px 12px",
                                borderRadius: "5px",
                                backgroundColor: "#28a745",
                                color: "white",
                                border: "none",
                                cursor: "pointer"
                            }}
                        >
                            Add
                        </button>
                    </div>

                    {newTags.length > 0 && (
                        <div style={{ marginTop: "10px" }}>
                            {newTags.map((tag, i) => (
                                <span
                                    key={i}
                                    style={{
                                        display: "inline-block",
                                        backgroundColor: "#eee",
                                        padding: "3px 8px",
                                        borderRadius: "4px",
                                        marginRight: "6px",
                                        marginTop: "4px"
                                    }}
                                >
                                    {tag}
                                </span>
                            ))}
                        </div>
                    )}
                </div>


                <button
                    type="submit"
                    style={{
                        marginTop: "15px",
                        padding: "10px",
                        backgroundColor: "#007bff",
                        color: "white",
                        borderRadius: "5px",
                        border: "none",
                        cursor: "pointer",
                        fontWeight: "bold"
                    }}
                >
                    {movie ? "Update Movie" : "Create Movie"}
                </button>
            </form>
        </div>
    );
};

export default MovieForm;
