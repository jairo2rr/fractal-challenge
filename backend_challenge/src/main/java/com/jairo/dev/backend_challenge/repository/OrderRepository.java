package com.jairo.dev.backend_challenge.repository;

import com.jairo.dev.backend_challenge.model.Order;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderRepository extends CrudRepository<Order, Long> {

}
