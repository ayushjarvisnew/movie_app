import React, { useEffect, useState } from "react";
import axios from "axios";

const Theatres = () => {
    const [theatres, setTheatres] = useState([]);

    const token = localStorage.getItem("token");

    const fetchTheatres = () => {
        axios.get("/theatres", {
            headers: { Authorization: `Bearer ${token}` }
        })
            .then(res => {
                const data = Array.isArray(res.data) ? res.data : [];
                setTheatres(data);
            })
            .catch(err => console.error("Error fetching theatres:", err));
    };

    useEffect(() => {
        fetchTheatres();
    }, []);

    const handleDelete = id => {
        if (window.confirm("Are you sure you want to delete this theatre?")) {
            axios.delete(`/theatres/${id}`, {
                headers: { Authorization: `Bearer ${token}` }
            })
                .then(() => fetchTheatres())
                .catch(err => console.error("Error deleting theatre:", err));
        }
    };

    const handleEdit = (theatre) => {
        window.dispatchEvent(new CustomEvent('editTheatre', { detail: theatre }));
    };

    return (
        <div style={{ textAlign: "center", padding: "20px" }}>
            <h1>Theatres</h1>
            <div style={{ display: "flex", flexWrap: "wrap", justifyContent: "center" }}>
                {theatres.length > 0 ? theatres.map(theatre => (
                    <div key={theatre.id} style={{
                        border: "1px solid #ccc",
                        borderRadius: "8px",
                        margin: "10px",
                        padding: "15px",
                        width: "250px",
                        boxShadow: "0 2px 5px rgba(0,0,0,0.2)",
                        textAlign: "left",
                        position: "relative"
                    }}>
                        <h3>{theatre.name}</h3>
                        <p><strong>Address:</strong> {theatre.address}</p>
                        <p><strong>City:</strong> {theatre.city}, <strong>State:</strong> {theatre.state}</p>
                        <p><strong>Country:</strong> {theatre.country}</p>
                        <p><strong>Rating:</strong> {theatre.rating}</p>

                        <div style={{ display: "flex", justifyContent: "space-between", marginTop: "10px" }}>
                            <button onClick={() => handleEdit(theatre)}
                                    style={{
                                        padding: "6px 12px",
                                        borderRadius: "5px",
                                        backgroundColor: "#007bff",
                                        color: "white",
                                        border: "none",
                                        cursor: "pointer"
                                    }}
                            >
                                Edit
                            </button>
                            <button onClick={() => handleDelete(theatre.id)}
                                    style={{
                                        padding: "6px 12px",
                                        borderRadius: "5px",
                                        backgroundColor: "#dc3545",
                                        color: "white",
                                        border: "none",
                                        cursor: "pointer"
                                    }}
                            >
                                Delete
                            </button>
                        </div>
                    </div>
                )) : <p>No theatres available</p>}
            </div>
        </div>
    );
};

export default Theatres;
