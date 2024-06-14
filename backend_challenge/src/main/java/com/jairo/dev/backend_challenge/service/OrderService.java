package com.jairo.dev.backend_challenge.service;

import com.jairo.dev.backend_challenge.model.Order;
import com.jairo.dev.backend_challenge.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderService {
    private final OrderRepository orderRepository;

    public List<Order> findAllOrders() {
        return (List<Order>) orderRepository.findAll();
    }

    public Order findOrderById(Long id) {
        return orderRepository.findById(id).orElseThrow();
    }

    public Order saveOrder(Order order) {
        return orderRepository.save(order);
    }

    public Order updateOrder(Order order) {
        Order orderFound = orderRepository.findById(order.getId()).orElseThrow();
        orderFound.setOrderDetails(order.getOrderDetails());
        orderFound.setOrderStatus(order.getOrderStatus());
        orderFound.setNOrder(order.getNOrder());
        return orderRepository.save(order);
    }

    public void deleteOrderById(Long id) {
        orderRepository.deleteById(id);
    }
}

