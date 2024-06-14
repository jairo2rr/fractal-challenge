package com.jairo.dev.backend_challenge.controller;

import com.jairo.dev.backend_challenge.model.Order;
import com.jairo.dev.backend_challenge.model.Product;
import com.jairo.dev.backend_challenge.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class ProductController {
    public final ProductService productService;

    @ResponseStatus(HttpStatus.OK)
    @GetMapping("/products")
    public ResponseEntity<List<Product>> getOrders() {
        return ResponseEntity.ok(productService.getAllProducts());
    }

    @GetMapping("/product/{id}")
    public ResponseEntity<Product> getOrderById(@PathVariable Long id) {
        return new ResponseEntity<>(productService.getProductById(id), HttpStatus.CREATED);
    }

    @PostMapping("/product")
    public ResponseEntity<Product> createOrder(Product product) {
        return new ResponseEntity<>(productService.createProduct(product), HttpStatus.CREATED);
    }

    @PutMapping("/product")
    public ResponseEntity<Product> updateOrder(Product product) {
        return ResponseEntity.ok(productService.updateProduct(product));
    }

    @ResponseStatus(HttpStatus.ACCEPTED)
    @DeleteMapping("/product/{id}")
    public void deleteOrder(@PathVariable Long id) {
        productService.deleteProduct(id);
    }
}
