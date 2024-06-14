package com.jairo.dev.backend_challenge.repository;

import com.jairo.dev.backend_challenge.model.OrderDetail;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderDetailRepository extends CrudRepository<OrderDetail, Long> {
}
