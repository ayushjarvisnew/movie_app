import React, { useEffect, useState } from "react";
import axios from "axios";
import "../Css/TheatreForm.css"; // 👈 import CSS

const TheatreForm = ({ theatre = null, onSuccess }) => {
    const [name, setName] = useState("");
    const [address, setAddress] = useState("");
    const [city, setCity] = useState("");
    const [state, setState] = useState("");
    const [country, setCountry] = useState("");
    const [rating, setRating] = useState(0);

    const token = localStorage.getItem("token");

    useEffect(() => {
        if (theatre) {
            setName(theatre.name || "");
            setAddress(theatre.address || "");
            setCity(theatre.city || "");
            setState(theatre.state || "");
            setCountry(theatre.country || "");
            setRating(theatre.rating || 0);
        } else {
            resetForm();
        }
    }, [theatre]);

    const resetForm = () => {
        setName(""); setAddress(""); setCity(""); setState(""); setCountry(""); setRating(0);
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        const payload = { name, address, city, state, country, rating: parseFloat(rating) };
        const url = theatre ? `http://localhost:3000/theatres/${theatre.id}` : "http://localhost:3000/theatres";
        const method = theatre ? "patch" : "post";

        axios({ method, url, data: { theatre: payload }, headers: { Authorization: `Bearer ${token}` } })
            .then(res => {
                alert("Theatre saved successfully!");
                if (onSuccess) onSuccess(res.data);
                resetForm();
            })
            .catch(err => console.error("Error saving theatre:", err));
    };

    return (
        <div className="theatre-form-container">
            <h2 className="theatre-form-title">
                {theatre ? "Edit Theatre" : "Add New Theatre"}
            </h2>
            <form onSubmit={handleSubmit} className="theatre-form">
                <input type="text" placeholder="Name" value={name}
                       onChange={e => setName(e.target.value)} required className="theatre-input" />
                <input type="text" placeholder="Address" value={address}
                       onChange={e => setAddress(e.target.value)} required className="theatre-input" />
                <input type="text" placeholder="City" value={city}
                       onChange={e => setCity(e.target.value)} required className="theatre-input" />
                <input type="text" placeholder="State" value={state}
                       onChange={e => setState(e.target.value)} required className="theatre-input" />
                <input type="text" placeholder="Country" value={country}
                       onChange={e => setCountry(e.target.value)} required className="theatre-input" />
                <input type="number" step="0.1" min="0" max="5" placeholder="Rating"
                       value={rating} onChange={e => setRating(e.target.value)} className="theatre-input" />
                <button type="submit" className="theatre-btn">
                    {theatre ? "Update Theatre" : "Create Theatre"}
                </button>
            </form>
        </div>
    );
};

export default TheatreForm;
