import React, { useEffect, useState } from "react";
import axios from "axios";

const Screens = () => {
    const [screens, setScreens] = useState([]);
    const [loading, setLoading] = useState(true);

    const token = localStorage.getItem("token");

    const fetchScreens = async () => {
        setLoading(true);
        try {
            const res = await axios.get("http://localhost:3000/screens", {
                headers: { Authorization: `Bearer ${token}` },
            });
            const data = Array.isArray(res.data) ? res.data : [];
            setScreens(data);
        } catch (err) {
            console.error("Error fetching screens:", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchScreens();
    }, []);

    if (loading) return <p>Loading screens...</p>;

    return (
        <div className="p-6">
            <h1 className="text-3xl font-bold mb-6">Screens</h1>

            {screens.length === 0 ? (
                <p>No screens available.</p>
            ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6">
                    {screens.map((s) => (
                        <div
                            key={s.id}
                            className="border rounded-lg p-4 shadow hover:shadow-lg transition"
                        >
                            <h2 className="text-xl font-semibold">{s.name || "N/A"}</h2>
                            <p>Seats: {s.total_seats || "N/A"}</p>
                            <p>Theatre: {s.theatre?.name || "N/A"}</p>
                            <p>Type: {s.screen_type || "N/A"}</p>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default Screens;
