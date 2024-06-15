package com.jairo.dev.backend_challenge.model.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class OrderDTO {
    private Long id;
    private String orderDate;
    private Long orderNumber;
    private String orderStatus;
    private List<OrderDetailDTO> orderDetails;
}
