import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import "../Css/Home.css";
import { FaInstagram, FaTwitter, FaYoutube } from "react-icons/fa";

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

    useEffect(() => {
        const bannerInterval = setInterval(() => {
            setBannerIndex((prev) =>
                prev === bannerImages.length - 1 ? 0 : prev + 1
            );
        }, 4000);
        return () => clearInterval(bannerInterval);
    }, []);

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
            {/* ⭐⭐⭐ NEW GLASSMORPHISM HERO SECTION ⭐⭐⭐ */}
            <div className="hero-glass">
                <h1>Experience Movies Like Never Before</h1>
                <p>Fast booking • Real-time seat selection • Smooth payments</p>
                <Link to="/movies" className="hero-btn">
                    View Movies
                </Link>
            </div>

            <section className="features">
                <h2>🎬 Why Choose Us</h2>

                <div className="feature-card-grid">

                    <div className="feature-card">
                        <span className="feature-icon">🎟️</span>
                        <h3>Easy Online Booking</h3>
                        <p>Book tickets in seconds with our smooth and simple UI.</p>
                    </div>

                    <div className="feature-card">
                        <span className="feature-icon">💺</span>
                        <h3>Real-time Seat Selection</h3>
                        <p>Choose your seats live and get instant availability updates.</p>
                    </div>

                    <div className="feature-card">
                        <span className="feature-icon">💸</span>
                        <h3>Secure Payments</h3>
                        <p>Multiple payment modes with encrypted transactions.</p>
                    </div>

                    <div className="feature-card">
                        <span className="feature-icon">🍔</span>
                        <h3>Food & Beverage Deals</h3>
                        <p>Save more with special combo offers and snacks.</p>
                    </div>

                </div>
            </section>


            <section className="testimonials-section">
                <h2 className="title">💬 What Our Users Say</h2>

                <div className="glass-card fade-in">
                    <img
                        className="avatar"
                        src={`https://i.pravatar.cc/80?img=${testimonialIndex + 10}`}
                        alt="User"
                    />
                    <p className="text">“{testimonials[testimonialIndex].text}”</p>
                    <h4 className="name">— {testimonials[testimonialIndex].name}</h4>
                </div>

                <div className="indicator">
                    {testimonials.map((_, i) => (
                        <span
                            key={i}
                            className={i === testimonialIndex ? "dot active" : "dot"}
                            onClick={() => setTestimonialIndex(i)}
                        ></span>
                    ))}
                </div>
            </section>

            <section className="how-it-works">
                <h2>🧾 How It Works</h2>

                <div className="how-cards">

                    <div className="how-card">
                        <span className="how-icon">🎬</span>
                        <h3>Choose a Movie</h3>
                        <p>Browse all the latest movies available in your city.</p>
                    </div>

                    <div className="how-card">
                        <span className="how-icon">🕒</span>
                        <h3>Select Show</h3>
                        <p>Pick your preferred date and showtime.</p>
                    </div>

                    <div className="how-card">
                        <span className="how-icon">💺</span>
                        <h3>Pick Your Seats</h3>
                        <p>Select available seats in real-time with instant updates.</p>
                    </div>

                    <div className="how-card">
                        <span className="how-icon">💳</span>
                        <h3>Pay Securely</h3>
                        <p>Make safe payments using your preferred method.</p>
                    </div>

                    <div className="how-card">
                        <span className="how-icon">📄</span>
                        <h3>Download E-Ticket</h3>
                        <p>Instantly access your ticket and show it at the theatre.</p>
                    </div>

                </div>
            </section>

            <footer className="footer">
                <div className="footer-container">
                    {/* Centered logo with horizontal lines */}
                    <div className="footer-logo-line">
                        <span className="line"></span>
                        <span className="logo-text">Movie Reservation</span>
                        <span className="line"></span>
                    </div>

                    {/* Social links */}
                    <div className="footer-social">
                        <a
                            href="https://www.instagram.com/accounts/login/?next=%2Fbookmyshowin%2F&source=omni_redirect"
                            target="_blank"
                            rel="noopener noreferrer"
                            className="social-icon instagram"
                        >
                            <FaInstagram />
                        </a>
                        <a
                            href="https://x.com/BookMyShow/"
                            target="_blank"
                            rel="noopener noreferrer"
                            className="social-icon twitter"
                        >
                            <FaTwitter />
                        </a>
                        <a
                            href="https://www.youtube.com/user/BookMyShow/featured"
                            target="_blank"
                            rel="noopener noreferrer"
                            className="social-icon youtube"
                        >
                            <FaYoutube />
                        </a>
                    </div>

                    {/* Copyright */}
                    <p className="footer-copy">© 2025 MovieReservationSystem. All rights reserved. Designed and developed with ❤️ by Ayush Gupta.
                    </p>
                </div>
            </footer>
        </div>
    );
};

export default Home;

