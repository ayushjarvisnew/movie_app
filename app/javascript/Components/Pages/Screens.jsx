import React, { useEffect, useState } from "react";
import axios from "axios";
import ScreenForm from "./ScreenForm";

const Screens = () => {
    const [screens, setScreens] = useState([]);
    const [loading, setLoading] = useState(true);
    const [selectedScreen, setSelectedScreen] = useState(null);
    const token = localStorage.getItem("token");

    const fetchScreens = async () => {
        setLoading(true);
        try {
            const res = await axios.get("/screens", {
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

    const handleEdit = (screen) => {
        setSelectedScreen(screen);
        window.scrollTo({ top: 0, behavior: "smooth" }); // Scroll to form
    };

    const handleDelete = async (id) => {
        if (!window.confirm("Are you sure you want to delete this screen?")) return;
        try {
            await axios.delete(`/screens/${id}`, {
                headers: { Authorization: `Bearer ${token}` },
            });
            fetchScreens();
        } catch (err) {
            console.error("Error deleting screen:", err);
        }
    };

    const handleSuccess = () => {
        fetchScreens();
        setSelectedScreen(null);
    };

    if (loading) return <p className="p-6 text-lg">Loading screens...</p>;

    return (
        <div className="p-6">
            <h1 className="text-3xl font-bold mb-6 text-blue-600">Screens Management</h1>

            <ScreenForm screen={selectedScreen} onSuccess={handleSuccess} />

            {screens.length === 0 ? (
                <p>No screens available.</p>
            ) : (
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 mt-6">
                    {screens.map((s) => (
                        <div
                            key={s.id}
                            className="border rounded-lg p-4 shadow hover:shadow-lg transition"
                        >
                            <h2 className="text-xl font-semibold mb-1">{s.name || "N/A"}</h2>
                            <p>Seats: {s.total_seats || "N/A"}</p>
                            <p>Theatre: {s.theatre?.name || "N/A"}</p>
                            <p>Type: {s.screen_type || "N/A"}</p>

                            <div className="flex gap-3 mt-3">
                                <button
                                    onClick={() => handleEdit(s)}
                                    className="bg-yellow-500 text-white px-3 py-1 rounded hover:bg-yellow-600 transition"
                                >
                                    Edit
                                </button>
                                <button
                                    onClick={() => handleDelete(s.id)}
                                    className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 transition"
                                >
                                    Delete
                                </button>
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};

export default Screens;
