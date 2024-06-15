package com.jairo.dev.backend_challenge.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.jairo.dev.backend_challenge.model.dto.OrderDTO;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "orders")
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long orderNumber;
    private LocalDateTime orderDate;
    private String orderStatus;
    @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, mappedBy = "order", orphanRemoval = true)
    private List<OrderDetail> orderDetails;

    public OrderDTO toDTO(){
        return OrderDTO.builder()
                .id(id)
                .orderNumber(orderNumber)
                .orderStatus(orderStatus)
                .orderDetails(orderDetails.stream().map(OrderDetail::toDTO).toList())
                .orderDate(orderDate.toString())
                .build();
    }
}
