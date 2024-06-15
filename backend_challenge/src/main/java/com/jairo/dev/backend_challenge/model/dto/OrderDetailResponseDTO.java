package com.jairo.dev.backend_challenge.model.dto;

import com.jairo.dev.backend_challenge.model.Product;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class OrderDetailResponseDTO {
    private Long id;
    private Product product ;
    private Long quantity;
    private Float totalPrice;
}
