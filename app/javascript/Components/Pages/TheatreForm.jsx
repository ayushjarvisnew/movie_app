import React, { useEffect, useState } from "react";
import axios from "axios";

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
        <div style={{
            backgroundColor: "#f0f8ff",
            padding: "20px",
            borderRadius: "10px",
            boxShadow: "0 3px 10px rgba(0,0,0,0.1)"
        }}>
            <h2 style={{ textAlign: "center", marginBottom: "20px" }}>
                {theatre ? "Edit Theatre" : "Add New Theatre"}
            </h2>
            <form onSubmit={handleSubmit} style={{ display: "flex", flexDirection: "column", gap: "12px" }}>
                <input type="text" placeholder="Name" value={name} onChange={e => setName(e.target.value)} required
                       style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="text" placeholder="Address" value={address} onChange={e => setAddress(e.target.value)} required
                       style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="text" placeholder="City" value={city} onChange={e => setCity(e.target.value)} required
                       style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="text" placeholder="State" value={state} onChange={e => setState(e.target.value)} required
                       style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="text" placeholder="Country" value={country} onChange={e => setCountry(e.target.value)} required
                       style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />
                <input type="number" step="0.1" min="0" max="5" placeholder="Rating" value={rating} onChange={e => setRating(e.target.value)}
                       style={{ padding: "8px", borderRadius: "5px", border: "1px solid #ccc" }} />

                <button type="submit" style={{
                    marginTop: "15px",
                    padding: "10px",
                    backgroundColor: "#007bff",
                    color: "white",
                    borderRadius: "5px",
                    border: "none",
                    cursor: "pointer",
                    fontWeight: "bold"
                }}>
                    {theatre ? "Update Theatre" : "Create Theatre"}
                </button>
            </form>
        </div>
    );
};

export default TheatreForm;
