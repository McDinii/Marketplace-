import React, { useState, useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import { Row, Col } from 'react-bootstrap'
import Product from '../components/Product'
import Loader from '../components/Loader'
import Message from '../components/Message'
import Paginate from '../components/Paginate'
import CategoryFilter from '../components/Category';
import ProductCarousel from '../components/ProductCarousel'
import { listProducts } from '../actions/productActions'
import category from "../components/Category";


function HomeScreen({ history }) {
    const dispatch = useDispatch()
    const productList = useSelector(state => state.productList)
    const { error, loading, products, page, pages } = productList

    let keyword = history.location.search
    const [category, setCategory] = useState('');
    const [categories, setCategories] = useState([]);
    const handleCategoryChange = (selectedCategory) => {
    setCategory(selectedCategory);
  };
useEffect(() => {
    const category = new URLSearchParams(keyword).get('category') || '';
    dispatch(listProducts(keyword, category));

    // Пример получения списка категорий из API
    // Вместо этого примера вам нужно добавить код для получения списка категорий из API
    const fetchCategories = async () => {
      try {
        const response = await fetch('/api/products/categories');
        const data = await response.json();
        setCategories(data.categories);
      } catch (error) {
        console.error('Failed to fetch categories:', error);
      }
    };

    fetchCategories();

  }, [dispatch, keyword]);

    return (
    <div>
      {!keyword && <ProductCarousel />}

      <h1>Products</h1>
      {loading ? (
        <Loader />
      ) : error ? (
        <Message variant='danger'>{error}</Message>
      ) : (
        <div>
          <CategoryFilter
            categories={categories} // Передача списка категорий в компонент CategoryFilter
            handleCategoryChange={handleCategoryChange}
          />
          <Row>
            {products
              .filter((product) => (category ? product.category === category : true))
              .map((product) => (
                <Col key={product._id} sm={12} md={6} lg={4} xl={3}>
                  <Product product={product} />
                </Col>
              ))}
          </Row>
          <Paginate page={page} pages={pages} keyword={keyword} category={category} />
        </div>
      )}
    </div>
  );
}

export default HomeScreen
