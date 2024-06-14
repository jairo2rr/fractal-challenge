package com.jairo.dev.backend_challenge.model;

import com.fasterxml.jackson.annotation.JsonFormat;
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
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss.SSSSSS")
    private LocalDateTime orderDate;
    private String orderStatus;
    @OneToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL, targetEntity = OrderDetail.class)
    @JoinColumn(name = "order_id",referencedColumnName = "id")
    private List<OrderDetail> orderDetails;
}
