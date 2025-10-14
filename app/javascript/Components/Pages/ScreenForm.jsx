import React, { useState, useEffect } from "react";
import axios from "axios";

const ScreenForm = ({ screen, onSuccess }) => {
    const [name, setName] = useState(screen?.name || "");
    const [totalSeats, setTotalSeats] = useState(screen?.total_seats || "");
    const [screenType, setScreenType] = useState(screen?.screen_type || "2D");
    const [theatreId, setTheatreId] = useState(screen?.theatre?.id || "");
    const [theatres, setTheatres] = useState([]);
    const [loading, setLoading] = useState(false);

    const token = localStorage.getItem("token");

    useEffect(() => {
        axios
            .get("http://localhost:3000/theatres", {
                headers: { Authorization: `Bearer ${token}` },
            })
            .then((res) => {
                const data = Array.isArray(res.data) ? res.data : [];
                setTheatres(data);
            })
            .catch((err) => console.error("Error fetching theatres:", err));
    }, []);

    const handleSubmit = (e) => {
        e.preventDefault();
        setLoading(true);

        const payload = {
            screen: {
                name,
                total_seats: parseInt(totalSeats),
                screen_type: screenType,
                theatre_id: theatreId,
            },
        };

        const request = screen
            ? axios.put(`http://localhost:3000/screens/${screen.id}`, payload, {
                headers: { Authorization: `Bearer ${token}` },
            })
            : axios.post("http://localhost:3000/screens", payload, {
                headers: { Authorization: `Bearer ${token}` },
            });

        request
            .then(() => {
                setName("");
                setTotalSeats("");
                setScreenType("2D");
                setTheatreId("");
                if (onSuccess) onSuccess();
            })
            .catch((err) => console.error("Error saving screen:", err))
            .finally(() => setLoading(false));
    };

    return (
        <form onSubmit={handleSubmit} style={{ marginBottom: "20px" }}>
            <h3>{screen ? "Edit Screen" : "Add New Screen"}</h3>
            <input
                type="text"
                placeholder="Screen Name"
                value={name}
                onChange={(e) => setName(e.target.value)}
                required
                style={{ marginRight: "10px", padding: "6px", borderRadius: "5px", border: "1px solid #ccc" }}
            />
            <input
                type="number"
                placeholder="Total Seats (100-500)"
                value={totalSeats}
                onChange={(e) => setTotalSeats(e.target.value)}
                required
                min={100}
                max={500}
                style={{ marginRight: "10px", padding: "6px", borderRadius: "5px", border: "1px solid #ccc" }}
            />
            <select
                value={screenType}
                onChange={(e) => setScreenType(e.target.value)}
                required
                style={{ marginRight: "10px", padding: "6px", borderRadius: "5px", border: "1px solid #ccc" }}
            >
                <option value="2D">2D</option>
                <option value="3D">3D</option>
                <option value="IMAX">IMAX</option>
                <option value="4DX">4DX</option>
                <option value="Dolby Cinema">Dolby Cinema</option>
            </select>

            <select
                value={theatreId}
                onChange={(e) => setTheatreId(e.target.value)}
                required
                style={{ marginRight: "10px", padding: "6px", borderRadius: "5px", border: "1px solid #ccc" }}
            >
                <option value="">Select Theatre</option>
                {theatres.map((t) => (
                    <option key={t.id} value={t.id}>
                        {t.name}
                    </option>
                ))}
            </select>

            <button
                type="submit"
                disabled={loading}
                style={{
                    padding: "8px 12px",
                    backgroundColor: "#007bff",
                    color: "white",
                    borderRadius: "5px",
                    border: "none",
                    cursor: "pointer",
                    fontWeight: "bold",
                }}
            >
                {loading ? "Saving..." : screen ? "Update" : "Add"}
            </button>
        </form>
    );
};

export default ScreenForm;
