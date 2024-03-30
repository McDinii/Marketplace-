import React, {useState, useEffect} from 'react'
import {Form, Button} from 'react-bootstrap'
import {useDispatch, useSelector} from 'react-redux'
import FormContainer from '../components/FormContainer'
import CheckoutSteps from '../components/CheckoutSteps'
import {saveShippingAddress} from '../actions/cartActions'
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

function ShippingScreen({history}) {

    const cart = useSelector(state => state.cart)
    const {shippingAddress} = cart

    const dispatch = useDispatch()

    const [address, setAddress] = useState(shippingAddress.address)
    const [city, setCity] = useState(shippingAddress.city)
    const [postalCode, setPostalCode] = useState(shippingAddress.postalCode)
    const [country, setCountry] = useState(shippingAddress.country)
    const [deliveryTime, setDeliveryTime] = useState(shippingAddress.deliveryTime);
    const [deliveryDate, setDeliveryDate] = useState(shippingAddress.deliveryDate);
    const submitHandler = (e) => {
        e.preventDefault()
        const deliveryDateTime = new Date(deliveryDate + 'T' + deliveryTime);
        dispatch(saveShippingAddress({address, city, postalCode, country, deliveryDateTime}))
        history.push('/payment')
    }

    return (
        <FormContainer>
            <CheckoutSteps step1 step2/>
            <h1>Shipping</h1>
            <Form onSubmit={submitHandler}>

                <Form.Group controlId='address'>
                    <Form.Label>Address</Form.Label>
                    <Form.Control
                        required
                        type='text'
                        placeholder='Enter address'
                        value={address ? address : ''}
                        onChange={(e) => setAddress(e.target.value)}
                    >
                    </Form.Control>
                </Form.Group>

                <Form.Group controlId='city'>
                    <Form.Label>City</Form.Label>
                    <Form.Control
                        required
                        type='text'
                        placeholder='Enter city'
                        value={city ? city : ''}
                        onChange={(e) => setCity(e.target.value)}
                    >
                    </Form.Control>
                </Form.Group>

                <Form.Group controlId='postalCode'>
                    <Form.Label>Postal Code</Form.Label>
                    <Form.Control
                        required
                        type='text'
                        placeholder='Enter postal code'
                        value={postalCode ? postalCode : ''}
                        onChange={(e) => setPostalCode(e.target.value)}
                    >
                    </Form.Control>
                </Form.Group>

                <Form.Group controlId='country'>
                    <Form.Label>Country</Form.Label>
                    <Form.Control
                        required
                        type='text'
                        placeholder='Enter country'
                        value={country ? country : ''}
                        onChange={(e) => setCountry(e.target.value)}
                    >
                    </Form.Control>
                </Form.Group>

                <Form.Group controlId='deliveryTime'>
                    <Form.Label>Delivery Time</Form.Label>
                    <Form.Control
                        required
                        type='time'
                        placeholder='Enter delivery time'
                        value={deliveryTime ? deliveryTime : ''}
                        onChange={(e) => setDeliveryTime(e.target.value)}
                    >
                    </Form.Control>
                </Form.Group>
                <Form.Group controlId='deliveryDate'>
                    <Form.Label>Delivery Date</Form.Label>
                    <Form.Control
                        required
                        type='date'
                        placeholder='Enter delivery date'
                        value={deliveryDate ? deliveryDate : ''}
                        onChange={(e) => setDeliveryDate(e.target.value)}
                    >
                    </Form.Control>
                </Form.Group>
                <Button type='submit' variant='primary'>
                    Continue
                </Button>
            </Form>
        </FormContainer>
    )
}

export default ShippingScreen
