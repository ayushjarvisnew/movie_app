import React, { useState, useEffect } from "react";
import axios from "axios";
import "../Css/MovieForm.css";

const MovieForm = ({ movie = null, onSuccess, onCancel  }) => {
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
        axios.get("/tags", { headers: { Authorization: `Bearer ${token}` } })
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
        const payload = {
            title, description, poster_image: posterImage,
            release_date: releaseDate, duration, rating,
            tag_ids: selectedTags, new_tags: newTags
        };
        const url = movie ? `/api/movies/${movie.id}` : "/axios/movies";
        const method = movie ? "patch" : "post";

        axios({ method, url, data: { movie: payload }, headers: { Authorization: `Bearer ${token}` } })
            .then(res => {
                setSuccessMessage("🎬 Movie saved successfully!");
                if (onSuccess) onSuccess(res.data);
                resetForm();
                setTimeout(() => setSuccessMessage(""), 3000);
            })
            .catch(err => console.error("Error saving movie:", err));
    };

    const resetForm = () => {
        setTitle(""); setDescription(""); setPosterImage(""); setReleaseDate("");
        setDuration(""); setRating(0); setSelectedTags([]); setNewTags([]); setNewTagInput("");
    };

    const handleCancel = () => {
        resetForm(); // ✅ Clear form
        if (onCancel) onCancel(); // ✅ Notify parent to switch back to "create mode"
    };

    return (
        <div className="movie-form-container">
            <h2 className="movie-form-title">{movie ? "Edit Movie" : "Add New Movie"}</h2>

            {successMessage && <div className="movie-success-message">{successMessage}</div>}

            <form onSubmit={handleSubmit} className="movie-form">
                <input type="text" placeholder="Title" value={title} onChange={e => setTitle(e.target.value)} required className="movie-input" />
                <input type="text" placeholder="Poster Image URL" value={posterImage} onChange={e => setPosterImage(e.target.value)} required className="movie-input" />
                <input type="date" value={releaseDate} onChange={e => setReleaseDate(e.target.value)} required className="movie-input" />
                <input type="number" placeholder="Duration (minutes)" value={duration} onChange={e => setDuration(e.target.value)} required className="movie-input" />
                <input type="number" step="0.1" min="0" max="5" placeholder="Rating" value={rating} onChange={e => setRating(e.target.value)} className="movie-input" />

                <textarea placeholder="Description" value={description} onChange={e => setDescription(e.target.value)} required className="movie-textarea" />

                <div className="movie-tag-section">
                    <label>Existing Tags:</label>
                    <div className="movie-tag-list">
                        {tagOptions.map(tag => (
                            <label key={tag.id} className="movie-tag-item">
                                <input type="checkbox" checked={selectedTags.includes(tag.id)} onChange={() => handleTagChange(tag.id)} />
                                {tag.name}
                            </label>
                        ))}
                    </div>
                </div>

                <div className="movie-tag-section">
                    <label>Add New Tag:</label>
                    <div className="movie-new-tag-container">
                        <input type="text" placeholder="Enter new tag" value={newTagInput} onChange={e => setNewTagInput(e.target.value)} className="movie-input" />
                        <button type="button" onClick={handleAddNewTag} className="movie-add-btn">Add</button>
                    </div>
                    {newTags.length > 0 && (
                        <div>
                            {newTags.map((tag, i) => (
                                <span key={i} className="movie-tag-chip">{tag}</span>
                            ))}
                        </div>
                    )}
                </div>

                <div className="movie-form-buttons">
                    <button type="submit" className="movie-submit-btn">
                        {movie ? "Update Movie" : "Create Movie"}
                    </button>

                    {movie && (
                        <button
                            type="button"
                            className="movie-cancel-btn"
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

export default MovieForm;
