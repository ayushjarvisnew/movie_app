import React, { useEffect, useState } from "react";
import axios from "axios";

const UserDashboard = () => {
    const [user, setUser] = useState(null);
    const [reservations, setReservations] = useState([]);
    const [loading, setLoading] = useState(true);
    const [cancelling, setCancelling] = useState(null);

    const token = localStorage.getItem("token");
    const headers = { Authorization: `Bearer ${token}` };

    // Fetch user info and reservations
    const fetchData = () => {
        if (!token) {
            setLoading(false);
            return;
        }

        setLoading(true);

        // User info
        axios
            .get("http://localhost:3000/current_user", { headers })
            .then((res) => setUser(res.data.user))
            .catch((err) => console.error("User fetch error:", err));

        // Reservations
        axios
            .get("http://localhost:3000/reservations/my_reservations", { headers })
            .then((res) => {
                const data = Array.isArray(res.data) ? res.data : res.data.reservations || [];
                setReservations(data);
            })
            .catch((err) => console.error("Reservations fetch error:", err))
            .finally(() => setLoading(false));
    };

    useEffect(() => {
        fetchData();
    }, []);

    const handleCancel = async (reservationId, showtimeId) => {
        if (!window.confirm("Are you sure you want to cancel this reservation?")) return;

        setCancelling(reservationId);
        try {
            await axios.delete(`http://localhost:3000/reservations/${reservationId}`, { headers });
            alert("Reservation cancelled successfully!");

            // Refresh reservations
            fetchData();

            // If SeatSelection is open, refresh seats
            const event = new CustomEvent("seat-refresh", { detail: { showtimeId } });
            window.dispatchEvent(event);

        } catch (err) {
            console.error("Cancel error:", err);
            alert(err.response?.data?.error || "Failed to cancel reservation");
        } finally {
            setCancelling(null);
        }
    };


    if (loading) return <p>Loading dashboard...</p>;
    if (!user) return <p>Please login to see your dashboard.</p>;

    return (
        <div style={{ padding: "20px" }}>
            <h2>Welcome, {user.name}</h2>

            <h3>Your Reservations:</h3>
            {reservations.length === 0 ? (
                <p>No reservations yet.</p>
            ) : (
                <table border="1" cellPadding="10" style={{ margin: "auto" }}>
                    <thead>
                    <tr>
                        <th>Movie</th>
                        <th>Theatre</th>
                        <th>Showtime</th>
                        <th>Seats</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    {reservations.map((res) => (
                        <tr key={res.id}>
                            <td>{res.movie_title || res.showtime?.movie?.title || "N/A"}</td>
                            <td>{res.theatre_name || res.showtime?.screen?.theatre?.name || "N/A"}</td>
                            <td>
                                {res.showtime_time
                                    ? new Date(res.showtime_time).toLocaleString("en-GB", {
                                        day: "2-digit",
                                        month: "short",
                                        year: "numeric",
                                        hour: "2-digit",
                                        minute: "2-digit",
                                    })
                                    : "N/A"}
                            </td>
                            <td>
                                {Array.isArray(res.seats)
                                    ? res.seats.map((seat) => (typeof seat === "string" ? seat : `${seat.row}${seat.seat_number}`)).join(", ")
                                    : "N/A"}
                            </td>
                            <td>{res.total_amount ? `₹${res.total_amount}` : "N/A"}</td>
                            <td style={{ color: res.cancelled ? "red" : res.payment_status === "paid" ? "green" : "orange", fontWeight: "bold" }}>
                                {res.cancelled ? "Cancelled" : res.payment_status || "N/A"}
                            </td>
                            <td>
                                {res.cancelled || new Date(res.showtime_time) < new Date() ? "Past" : <button onClick={() => handleCancel(res.id)}>Cancel</button>}
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
