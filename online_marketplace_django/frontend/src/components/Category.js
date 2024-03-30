import React, { useState, useEffect } from 'react';

const CategoryFilter = ({ categories, handleCategoryChange }) => {
  const [selectedCategory, setSelectedCategory] = useState('');

  const handleChange = (e) => {
    setSelectedCategory(e.target.value);
    handleCategoryChange(e.target.value);
  };

  return (
    <select value={selectedCategory} onChange={handleChange}>
      <option value="">All</option>
      {categories.map((category) => (
        <option key={category._id} value={category._id}>
          {category.name}
        </option>
      ))}
    </select>
  );
};

export default CategoryFilter;
