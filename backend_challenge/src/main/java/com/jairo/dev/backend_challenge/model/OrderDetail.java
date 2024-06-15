package com.jairo.dev.backend_challenge.model;

import com.jairo.dev.backend_challenge.model.dto.OrderDetailDTO;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Objects;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "order_details")
public class OrderDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "product_id")
    private Product product;
    private Long quantity;
    private Float totalPrice;

    @ManyToOne
    private Order order;

    public OrderDetailDTO toDTO(){
        return OrderDetailDTO.builder()
                .id(id)
                .product(product)
                .quantity(quantity)
                .totalPrice(totalPrice)
                .build();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        OrderDetail that = (OrderDetail) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hashCode(id);
    }
}
