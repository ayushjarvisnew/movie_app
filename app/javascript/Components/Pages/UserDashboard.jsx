import React, { useEffect, useState } from "react";
import axios from "axios";
import { jsPDF } from "jspdf";
import "jspdf-autotable";

const UserDashboard = () => {
    const [user, setUser] = useState(null);
    const [reservations, setReservations] = useState([]);
    const [loading, setLoading] = useState(true);
    const [cancelling, setCancelling] = useState(null);

    const token = localStorage.getItem("token");
    const headers = { Authorization: `Bearer ${token}` };

    const fetchData = async () => {
        if (!token) {
            setLoading(false);
            return;
        }

        setLoading(true);
        try {
            const [userRes, reservationRes] = await Promise.all([
                axios.get("/current_user", { headers }),
                axios.get("/reservations/my_reservations", { headers }),
            ]);

            setUser(userRes.data.user);

            const resData = Array.isArray(reservationRes.data)
                ? reservationRes.data
                : reservationRes.data.reservations || [];

            setReservations(resData);
        } catch (err) {
            console.error("Dashboard fetch error:", err);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleCancel = async (reservationId, showtimeId) => {
        if (!window.confirm("Are you sure you want to cancel this reservation?")) return;

        setCancelling(reservationId);
        try {
            await axios.delete(`/reservations/${reservationId}`, { headers });
            alert("Reservation cancelled successfully!");
            fetchData();

            const event = new CustomEvent("seat-refresh", { detail: { showtimeId } });
            window.dispatchEvent(event);
        } catch (err) {
            console.error("Cancel error:", err);
            alert(err.response?.data?.error || "Failed to cancel reservation");
        } finally {
            setCancelling(null);
        }
    };


    const handleDownload = (res) => {
        const doc = new jsPDF();
        doc.setFontSize(18);
        doc.text("🎟️ Movie Ticket", 14, 20);
        doc.setFontSize(12);
        doc.text(`Reservation ID: ${res.id}`, 14, 35);

        const movie = res.movie_title || res.showtime?.movie?.title || "N/A";
        const theatre = res.theatre_name || res.showtime?.screen?.theatre?.name || "N/A";
        const showtime = res.showtime_time
            ? new Date(res.showtime_time).toLocaleString()
            : "N/A";
        const seats = Array.isArray(res.seats)
            ? res.seats.join(", ")
            : "N/A";
        const price = res.total_amount ? `₹${res.total_amount}` : "N/A";

        doc.autoTable({
            startY: 45,
            head: [["Field", "Details"]],
            body: [
                ["Movie", movie],
                ["Theatre", theatre],
                ["Showtime", showtime],
                ["Seats", seats],
                ["Amount Paid", price],
            ],
        });

        doc.save(`Ticket_${res.id}.pdf`);
    };

    if (loading) return <p>Loading dashboard...</p>;
    if (!user) return <p>Please login to see your dashboard.</p>;

    return (
        <div style={{ padding: "20px" ,background:"black",color:"white" }}>
            <h1 style={{color:"orange"}}>Welcome {user.name}</h1>

            <h2>Your Reservations:</h2>
            {reservations.length === 0 ? (
                <p>No reservations yet.</p>
            ) : (
                <table border="1" cellPadding="10" style={{ margin: "auto", marginBottom: "30px" }}>
                    <thead>
                    <tr>
                        <th>Movie</th>
                        <th>Theatre</th>
                        <th>Showtime</th>
                        <th>Seats</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Action</th>
                        <th>Ticket</th>
                    </tr>
                    </thead>
                    <tbody>

                    {reservations.map((res) => (
                        <tr key={res.id}>
                            <td>{res.movie_title || "N/A"}</td>
                            <td>{res.theatre_name || "N/A"}</td>
                            <td>{res.showtime_time || "N/A"}</td>
                            <td>{Array.isArray(res.seats) ? res.seats.join(", ") : "N/A"}</td>
                            <td>{res.total_amount ? `₹${res.total_amount}` : "N/A"}</td>
                            <td
                                style={{
                                    color: res.cancelled
                                        ? "red"
                                        : res.payment_status === "success"
                                            ? "green"
                                            : "orange",
                                    fontWeight: "bold",
                                }}
                            >
                                {res.cancelled ? "Cancelled" : res.payment_status || "N/A"}
                            </td>
                            <td>
                                {/* 1. If the showtime is already over → Past */}
                                {new Date(res.showtime_time) < new Date() ? (
                                        "Past"
                                    ) :
                                    /* 2. If booking is already cancelled → Cancelled */
                                    res.cancelled ? (
                                            "Cancelled"
                                        ) :
                                        /* 3. If payment was successful → allow cancel button */
                                        res.payment_status === "success" ? (
                                            <button
                                                onClick={() => handleCancel(res.id, res.showtime_id)}
                                                disabled={cancelling === res.id}
                                            >
                                                {cancelling === res.id ? "Cancelling..." : "Cancel"}
                                            </button>
                                        ) : ("-")}
                            </td>
                            <td>
                                {res.payment_status === "success" && !res.cancelled ? (
                                    <button onClick={() => handleDownload(res)}>🎟️ Download Ticket</button>
                                ) : (
                                    "-"
                                )}
                            </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            )}
        </div>
    );
};

export default UserDashboard;
