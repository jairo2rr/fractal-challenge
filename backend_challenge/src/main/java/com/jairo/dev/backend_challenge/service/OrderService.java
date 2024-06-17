package com.jairo.dev.backend_challenge.service;

import com.jairo.dev.backend_challenge.model.Order;
import com.jairo.dev.backend_challenge.model.OrderDetail;
import com.jairo.dev.backend_challenge.model.Product;
import com.jairo.dev.backend_challenge.model.dto.OrderDTO;
import com.jairo.dev.backend_challenge.model.dto.OrderDetailDTO;
import com.jairo.dev.backend_challenge.repository.OrderDetailRepository;
import com.jairo.dev.backend_challenge.repository.OrderRepository;
import com.jairo.dev.backend_challenge.repository.ProductRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.RequiredArgsConstructor;
import lombok.extern.java.Log;
import lombok.extern.log4j.Log4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.swing.text.html.Option;
import java.io.Console;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final ProductRepository productRepository;
    private final OrderRepository orderRepository;
    private final OrderDetailRepository orderDetailRepository;

    public List<OrderDTO> findAllOrders() {
        List<Order> orders = (List<Order>) orderRepository.findAll();
        return orders.stream().map(Order::toDTO).toList();
    }

    public OrderDTO findOrderById(Long id) {
        return orderRepository.findById(id).orElseThrow().toDTO();
    }

    @Transactional
    public OrderDTO saveOrder(OrderDTO orderDTO) {

        Order order = new Order();

        Optional<Order> orderFound = orderRepository.findByOrderNumber(orderDTO.getOrderNumber());
        if(orderFound.isPresent()) {
            throw new DuplicateKeyException("Order number already exists");
        }

        DateTimeFormatter formatter = new DateTimeFormatterBuilder()
                .appendPattern("yyyy-MM-dd HH:mm:ss")
                .appendFraction(ChronoField.MICRO_OF_SECOND,1,6,true)
                .toFormatter();
        LocalDateTime localDateTime = LocalDateTime.parse(orderDTO.getOrderDate(), formatter);

        order.setOrderDate(localDateTime);
        order.setOrderStatus(orderDTO.getOrderStatus());
        order.setOrderNumber(orderDTO.getOrderNumber());
        order.setOrderDetails(new ArrayList<>());

        for(OrderDetailDTO orderDetailDTO : orderDTO.getOrderDetails()) {
            Product productFound = productRepository.findById(orderDetailDTO.getProduct().getId()).orElseThrow();
            OrderDetail newOrderDetail = new OrderDetail();
            newOrderDetail.setProduct(productFound);
            newOrderDetail.setQuantity(orderDetailDTO.getQuantity());
            newOrderDetail.setTotalPrice(orderDetailDTO.getTotalPrice());
            newOrderDetail.setOrder(order);
            order.getOrderDetails().add(newOrderDetail);
        }
        Order orderSaved = orderRepository.save(order);
        return orderSaved.toDTO();
    }

    @Transactional
    public OrderDTO updateOrder(OrderDTO orderDTO) {
        Order orderFound = orderRepository.findById(orderDTO.getId()).orElseThrow();
        List<OrderDetail> detailListOld = new ArrayList<>();
        List<OrderDetail> detailListCopy = orderFound.getOrderDetails();
        for (OrderDetailDTO orderDetailDTO : orderDTO.getOrderDetails()) {
            Optional<OrderDetail> orderDetailFound = orderFound.getOrderDetails().stream().filter(d -> Objects.equals(d.getId(), orderDetailDTO.getId())).findFirst();
            if (orderDetailFound.isPresent()) {
                orderDetailFound.get().setTotalPrice(orderDetailDTO.getTotalPrice());
                orderDetailFound.get().setQuantity(orderDetailDTO.getQuantity());
                detailListOld.add(orderDetailFound.get());
                detailListCopy =  detailListCopy.stream().filter(detail -> !Objects.equals(detail.getId(), orderDetailFound.get().getId())).toList();
            }else{
                Product productFound = productRepository.findById(orderDetailDTO.getProduct().getId()).orElseThrow();
                OrderDetail newOrderDetail = new OrderDetail();
                newOrderDetail.setQuantity(orderDetailDTO.getQuantity());
                newOrderDetail.setTotalPrice(orderDetailDTO.getTotalPrice());
                newOrderDetail.setOrder(orderFound);
                newOrderDetail.setProduct(productFound);
                orderFound.getOrderDetails().add(newOrderDetail);
            }
        }

        orderDetailRepository.saveAll(detailListOld);

        orderFound.setOrderStatus(orderDTO.getOrderStatus());
        orderFound.setOrderNumber(orderDTO.getOrderNumber());
        Order orderSaved = orderRepository.save(orderFound);

        if(!detailListCopy.isEmpty()) {
            for(OrderDetail orderDetail : detailListCopy) {
                orderDetailRepository.deleteById(orderDetail.getId());
            }
        }
        return orderSaved.toDTO();
    }

    public void deleteOrderById(Long id) {
        orderRepository.deleteById(id);
    }
}

