package com.jairo.dev.backend_challenge.model;

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
public class Order {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private Long nOrder;
    private LocalDateTime orderDate;
    private Integer state;
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL, targetEntity = OrderDetail.class)
    @JoinColumn(name = "order_id",referencedColumnName = "id")
    private List<OrderDetail> orderDetails;
}
