package com.jairo.dev.backend_challenge.service;

import com.jairo.dev.backend_challenge.model.Order;
import com.jairo.dev.backend_challenge.model.OrderDetail;
import com.jairo.dev.backend_challenge.repository.OrderDetailRepository;
import com.jairo.dev.backend_challenge.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.java.Log;
import lombok.extern.log4j.Log4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.Console;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OrderService {
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;

    public List<Order> findAllOrders() {
        return (List<Order>) orderRepository.findAll();
    }

    public Order findOrderById(Long id) {
        return orderRepository.findById(id).orElseThrow();
    }

    @Transactional
    public Order saveOrder(Order order) {
        return orderRepository.save(order);
    }

    @Transactional
    public Order updateOrder(Order order) {
        Order orderFound = orderRepository.findById(order.getId()).orElseThrow();
        for(OrderDetail orderDetail : order.getOrderDetails()) {
            if(orderFound.getOrderDetails().contains(orderDetail)) {
                
                orderDetailRepository.deleteById(orderDetail.getId());
            }
        }
        orderFound.setOrderDetails(order.getOrderDetails());
        orderFound.setOrderStatus(order.getOrderStatus());
        orderFound.setOrderNumber(order.getOrderNumber());
        return orderRepository.save(order);
    }

    public void deleteOrderById(Long id) {
        orderRepository.deleteById(id);
    }
}

