import React, {useState, useEffect} from 'react'
import {LinkContainer} from 'react-router-bootstrap'
import {Table, Button} from 'react-bootstrap'
import {useDispatch, useSelector} from 'react-redux'
import Loader from '../components/Loader'
import Message from '../components/Message'
import {listOrders} from '../actions/orderActions'
import PaginateOrder from '../components/OrderPaginate'

function OrderListScreen({history, match}) {
    const pageNumber = match.params.pageNumber || 1

    const dispatch = useDispatch()

    const orderList = useSelector(state => state.orderList)
    console.log("cc",orderList)
    const {loading, error, orders, page, pages} = orderList
    const userLogin = useSelector(state => state.userLogin)
    const {userInfo} = userLogin


    useEffect(() => {
        if (userInfo && userInfo.isAdmin) {
            dispatch(listOrders(pageNumber))
        } else {
            history.push('/login')
        }

    }, [dispatch, history, userInfo, pageNumber])

    return (
        <div>
            <h1>Orders</h1>
            {loading
                ? (<Loader/>)
                : error
                    ? (<Message variant='danger'>{error}</Message>)
                    : (
                        <Table striped bordered hover responsive className='table-sm'>
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>USER</th>
                                <th>DATE</th>
                                <th>Total</th>
                                <th>PAID</th>
                                <th>DELIVERED</th>
                                <th>DELIVERY TIME</th>
                                <th></th>
                            </tr>
                            </thead>

                            <tbody>
                            {console.log("ddd",orders)}
                            {orders && orders.map(order => (
                                <tr key={order._id}>
                                    <td>{order._id}</td>
                                    <td>{order.user && order.user.name}</td>
                                    <td>{ new Date(order.createdAt).toLocaleString()}</td>
                                    <td>${order.totalPrice}</td>
                                    <td>{order.isPaid ? (
                                        new Date(order.paidAt).toLocaleString()
                                    ) : (
                                        <i className='fas fa-check' style={{color: 'red'}}></i>
                                    )}
                                    </td>

                                    <td>{order.isDelivered ? (
                                        new Date(order.deliveredAt).toLocaleString()
                                    ) : (
                                        <i className='fas fa-check' style={{color: 'red'}}></i>
                                    )}
                                    </td>
                                    <td>{new Date(order.deliveryTime).toLocaleString()}</td>


                                    <td>
                                        <LinkContainer to={`/order/${order._id}`}>
                                            <Button variant='light' className='btn-sm'>
                                                Details
                                            </Button>
                                        </LinkContainer>


                                    </td>
                                </tr>
                            ))}
                            </tbody>
                        </Table>
                    )}
            <PaginateOrder pages={pages} page={page} isAdmin={true} />
        </div>
    )
}

export default OrderListScreen
