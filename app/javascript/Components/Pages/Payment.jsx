import React, { useEffect } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";

const Payment = () => {
    const navigate = useNavigate();
    const token = localStorage.getItem("token");

    useEffect(() => {
        const booking = JSON.parse(localStorage.getItem("pendingBooking"));
        if (!booking) {
            alert("No booking found.");
            navigate("/");
            return;
        }

        const initiatePayment = async () => {
            try {
                const res = await axios.post(
                    "/payments/initiate",
                    {
                        showtime_id: booking.showtimeId,
                        seat_ids: booking.selectedSeats,
                        amount: booking.totalPrice,
                        firstname: "User",
                        email: "user@gmail.com",
                        phone: "1234567890",
                        productinfo: "Movie Tickets",
                    },
                    { headers: { Authorization: `Bearer ${token}` } }
                );

                const data = res.data;

                const form = document.createElement("form");
                form.method = "POST";
                form.action = data.action;

                Object.keys(data).forEach((key) => {
                    const input = document.createElement("input");
                    input.type = "hidden";
                    input.name = key;
                    input.value = data[key];
                    form.appendChild(input);
                });

                document.body.appendChild(form);
                form.submit();

                localStorage.removeItem("pendingBooking");
            } catch (err) {
                console.error(err);
                alert("Payment initiation failed.");
                navigate("/");
            }
        };

        initiatePayment();
    }, [token, navigate]);

    return <div style={{ textAlign: "center", marginTop: "50px" }}>Redirecting to payment...</div>;
};

export default Payment;
