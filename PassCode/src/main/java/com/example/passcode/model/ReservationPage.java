package com.example.passcode.model;

import java.util.List;

/**
 * 预约分页数据包装类
 * 模拟Spring Data的Page接口
 */
public class ReservationPage {
    private List<Reservation> content;
    private int number; // 当前页码（0基础）
    private int size; // 每页大小
    private long totalElements; // 总记录数
    private int totalPages; // 总页数
    private boolean first; // 是否第一页
    private boolean last; // 是否最后一页
    private boolean hasNext; // 是否有下一页
    private boolean hasPrevious; // 是否有上一页

    public ReservationPage() {}

    public ReservationPage(List<Reservation> content, int number, int size, long totalElements) {
        this.content = content;
        this.number = number;
        this.size = size;
        this.totalElements = totalElements;
        this.totalPages = (int) Math.ceil((double) totalElements / size);
        this.first = (number == 0);
        this.last = (number >= totalPages - 1);
        this.hasNext = !last;
        this.hasPrevious = !first;
    }

    // Getter和Setter方法
    public List<Reservation> getContent() {
        return content;
    }

    public void setContent(List<Reservation> content) {
        this.content = content;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
        updatePageFlags();
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
        updateTotalPages();
    }

    public long getTotalElements() {
        return totalElements;
    }

    public void setTotalElements(long totalElements) {
        this.totalElements = totalElements;
        updateTotalPages();
    }

    public int getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(int totalPages) {
        this.totalPages = totalPages;
        updatePageFlags();
    }

    public boolean isFirst() {
        return first;
    }

    public boolean isLast() {
        return last;
    }

    public boolean hasNext() {
        return hasNext;
    }

    public boolean hasPrevious() {
        return hasPrevious;
    }

    private void updateTotalPages() {
        if (size > 0) {
            this.totalPages = (int) Math.ceil((double) totalElements / size);
            updatePageFlags();
        }
    }

    private void updatePageFlags() {
        this.first = (number == 0);
        this.last = (number >= totalPages - 1);
        this.hasNext = !last;
        this.hasPrevious = !first;
    }
}
