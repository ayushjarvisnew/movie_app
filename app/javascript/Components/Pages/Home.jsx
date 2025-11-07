import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import "../Css/Home.css";

const bannerImages = [
    "/images/banner1.jpg",
    "/images/banner2.jpg",
    "/images/banner3.jpg",
];

const testimonials = [
    { name: "Rahul K.", text: "Booking tickets has never been easier!" },
    { name: "Sneha P.", text: "Love the real-time seat selection feature!" },
    { name: "Amit R.", text: "Smooth payments and easy navigation." },
];

const Home = () => {
    const [bannerIndex, setBannerIndex] = useState(0);
    const [testimonialIndex, setTestimonialIndex] = useState(0);

    // Auto slide banners every 4 seconds
    useEffect(() => {
        const bannerInterval = setInterval(() => {
            setBannerIndex((prev) =>
                prev === bannerImages.length - 1 ? 0 : prev + 1
            );
        }, 4000);
        return () => clearInterval(bannerInterval);
    }, []);

    // Auto slide testimonials every 5 seconds
    useEffect(() => {
        const testimonialInterval = setInterval(() => {
            setTestimonialIndex((prev) =>
                prev === testimonials.length - 1 ? 0 : prev + 1
            );
        }, 5000);
        return () => clearInterval(testimonialInterval);
    }, []);

    return (
        <div className="home-page">
            <div className="full-carousel">
                {bannerImages.map((img, index) => (
                    <div
                        key={index}
                        className={`carousel-image ${
                            index === bannerIndex ? "active" : ""
                        }`}
                    >
                        <img src={img} alt={`Banner ${index}`} />
                    </div>
                ))}

                <button
                    className="nav-btn prev"
                    onClick={() =>
                        setBannerIndex(
                            bannerIndex === 0 ? bannerImages.length - 1 : bannerIndex - 1
                        )
                    }
                >
                    ❮
                </button>
                <button
                    className="nav-btn next"
                    onClick={() =>
                        setBannerIndex(
                            bannerIndex === bannerImages.length - 1 ? 0 : bannerIndex + 1
                        )
                    }
                >
                    ❯
                </button>

                <div className="dots">
                    {bannerImages.map((_, index) => (
                        <span
                            key={index}
                            className={index === bannerIndex ? "dot active" : "dot"}
                            onClick={() => setBannerIndex(index)}
                        ></span>
                    ))}
                </div>
            </div>

            <div className="home-content">
                <h1>Welcome to Movie Reservation System</h1>
                <p>Browse movies, book seats, and manage your reservations easily.</p>
                <Link to="/movies" className="button-link">
                    View Movies
                </Link>
            </div>

            <section className="features">
                <h2>🎬 Why Choose Us</h2>
                <div className="feature-grid">
                    <div>🎟️ <h3>Easy Online Booking</h3></div>
                    <div>💺 <h3>Real-time Seat Selection</h3></div>
                    <div>💸 <h3>Secure Payments</h3></div>
                    <div>🍔 <h3>Food & Beverage Deals</h3></div>
                </div>
            </section>

            <section className="how-it-works">
                <h2>🧾 How It Works</h2>
                <div className="steps">
                    <div><span>1️⃣</span> Choose a Movie</div>
                    <div><span>2️⃣</span> Select Show & Seats</div>
                    <div><span>3️⃣</span> Pay Securely & Get E-Ticket</div>
                </div>
            </section>

            <section className="testimonials">
                <h2>💬 What Our Users Say</h2>
                <div className="testimonial-box">
                    <p>“{testimonials[testimonialIndex].text}”</p>
                    <h4>— {testimonials[testimonialIndex].name}</h4>
                </div>
                <div className="testimonial-dots">
                    {testimonials.map((_, index) => (
                        <span
                            key={index}
                            className={
                                index === testimonialIndex ? "dot active" : "dot"
                            }
                            onClick={() => setTestimonialIndex(index)}
                        ></span>
                    ))}
                </div>
            </section>

            <section className="follow-us">
                <h2>📱 Stay Connected</h2>
                <div className="social-links">
                    <a href="https://www.instagram.com/accounts/login/?next=%2Fbookmyshowin%2F&source=omni_redirect"><i className="fab fa-instagram"></i> Instagram</a>
                    <a href="https://x.com/BookMyShow/"><i className="fab fa-twitter"></i> X (Twitter)</a>
                    <a href="https://www.youtube.com/user/BookMyShow/featured"><i className="fab fa-youtube"></i> YouTube</a>
                </div>
            </section>

            <footer className="footer">
                <div className="footer-links">
                    <h4>About | Terms | Privacy | Contact</h4>
                </div>
                <p>© 2025 MovieReservationSystem</p>
            </footer>
        </div>
    );
};

export default Home;

