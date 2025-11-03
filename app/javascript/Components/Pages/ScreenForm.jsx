import React, { useState, useEffect } from "react";
import axios from "axios";
import "../Css/ScreenForm.css"; // ✅ Add this line

const ScreenForm = ({ screen, onSuccess }) => {
    const [name, setName] = useState(screen?.name || "");
    const [totalSeats, setTotalSeats] = useState(screen?.seats || "");
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
        <div className="screen-form-container">
            <h3 className="screen-form-title">
                {screen ? "Edit Screen" : "Add New Screen"}
            </h3>

            <form onSubmit={handleSubmit} className="screen-form">
                <div className="form-group">
                    <label>Screen Name</label>
                    <input
                        type="text"
                        placeholder="Enter Screen Name"
                        value={name}
                        onChange={(e) => setName(e.target.value)}
                        required
                    />
                </div>

                <div className="form-group">
                    <label>Total Seats</label>
                    <input
                        type="number"
                        placeholder="Total Seats (100-500)"
                        value={totalSeats}
                        onChange={(e) => setTotalSeats(e.target.value)}
                        required
                        min={100}
                        max={500}
                    />
                </div>

                <div className="form-group">
                    <label>Screen Type</label>
                    <select
                        value={screenType}
                        onChange={(e) => setScreenType(e.target.value)}
                        required
                    >
                        <option value="2D">2D</option>
                        <option value="3D">3D</option>
                        <option value="IMAX">IMAX</option>
                        <option value="4DX">4DX</option>
                        <option value="Dolby Cinema">Dolby Cinema</option>
                    </select>
                </div>

                <div className="form-group">
                    <label>Select Theatre</label>
                    <select
                        value={theatreId}
                        onChange={(e) => setTheatreId(e.target.value)}
                        required
                    >
                        <option value="">Select Theatre</option>
                        {theatres.map((t) => (
                            <option key={t.id} value={t.id}>
                                {t.name}
                            </option>
                        ))}
                    </select>
                </div>

                <button type="submit" disabled={loading} className="submit-btn">
                    {loading ? "Saving..." : screen ? "Update Screen" : "Add Screen"}
                </button>
            </form>
        </div>
    );
};

export default ScreenForm;
