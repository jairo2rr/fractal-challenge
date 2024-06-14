package com.jairo.dev.backend_challenge.service;

import com.jairo.dev.backend_challenge.model.Product;
import com.jairo.dev.backend_challenge.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    public List<Product> getAllProducts() {
        return (List<Product>) productRepository.findAll();
    }

    public Product getProductById(Long id) {
        return productRepository.findById(id).orElseThrow();
    }

    public Product createProduct(Product product) {
        return productRepository.save(product);
    }

    @Transactional
    public Product updateProduct(Product product) {
        Product productFound = productRepository.findById(product.getId()).orElseThrow();
        productFound.setName(product.getName());
        productFound.setPrice(product.getPrice());
        productFound.setState(product.getState());
        return productRepository.save(productFound);
    }

    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }
}
