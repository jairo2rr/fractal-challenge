package com.jairo.dev.backend_challenge.controller;

import com.jairo.dev.backend_challenge.model.Order;
import com.jairo.dev.backend_challenge.model.dto.OrderDTO;
import com.jairo.dev.backend_challenge.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class OrderController {

    public final OrderService orderService;

    @ResponseStatus(HttpStatus.OK)
    @GetMapping("/orders")
    public ResponseEntity<List<OrderDTO>> getOrders() {
        return ResponseEntity.ok(orderService.findAllOrders());
    }

    @GetMapping("/order/{id}")
    public ResponseEntity<OrderDTO> getOrderById(@PathVariable Long id) {
        return new ResponseEntity<>(orderService.findOrderById(id), HttpStatus.OK);
    }

    @PostMapping("/order")
    public ResponseEntity<OrderDTO> createOrder(@RequestBody OrderDTO orderDTO) {
        return new ResponseEntity<>(orderService.saveOrder(orderDTO), HttpStatus.CREATED);
    }

    @PutMapping("/order")
    public ResponseEntity<OrderDTO> updateOrder(@RequestBody OrderDTO order) {
        return ResponseEntity.ok(orderService.updateOrder(order));
    }

    @ResponseStatus(HttpStatus.ACCEPTED)
    @DeleteMapping("/order/{id}")
    public void deleteOrder(@PathVariable Long id) {
        orderService.deleteOrderById(id);
    }
}
