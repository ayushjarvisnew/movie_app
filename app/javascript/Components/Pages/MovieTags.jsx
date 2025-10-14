import React from "react";
const MovieTags = ({ tags }) => {
    return (
        <p>
            Tags: {tags && tags.length > 0 ? tags.map(tag => tag.name).join(", ") : "No tags"}
        </p>
    );
};

export default MovieTags;
