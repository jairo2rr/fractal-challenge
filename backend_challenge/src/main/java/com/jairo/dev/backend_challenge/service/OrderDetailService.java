package com.jairo.dev.backend_challenge.service;

import com.jairo.dev.backend_challenge.model.OrderDetail;
import com.jairo.dev.backend_challenge.repository.OrderDetailRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderDetailService {
    private final OrderDetailRepository orderDetailRepository;
}
