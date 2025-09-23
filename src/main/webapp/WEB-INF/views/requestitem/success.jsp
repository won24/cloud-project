<%@ page contentType="text/html; charset=UTF-8" %>

<div class="success-container">
    <div class="success-content">
        <div class="success-icon">✓</div>
        <h2>경매품 신청이 완료되었습니다!</h2>
        <p>신청해 주신 경매품은 관리자 검토 후 승인됩니다.</p>
        <p>자세한 사항은 1:1 문의를 통해 안내드리겠습니다.</p>

        <div class="success-buttons">
            <button onclick="location.href='/auction'" class="btn-primary">
                경매 목록 보기
            </button>
            <button onclick="location.href='/customer/notice'" class="btn-secondary">
                공지사항 확인
            </button>
        </div>
    </div>
</div>

<style>
    .success-container {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 400px;
        padding: 40px 20px;
    }

    .success-content {
        text-align: center;
        max-width: 500px;
        padding: 40px;
        border: 2px solid #28a745;
        border-radius: 10px;
        background-color: #f8fff9;
    }

    .success-icon {
        font-size: 60px;
        color: #28a745;
        margin-bottom: 20px;
    }

    .success-content h2 {
        color: #28a745;
        margin-bottom: 20px;
    }

    .success-content p {
        margin-bottom: 15px;
        color: #666;
        line-height: 1.6;
    }

    .success-buttons {
        margin-top: 30px;
    }

    .success-buttons button {
        margin: 0 10px;
        padding: 12px 24px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: all 0.3s ease;
    }

    .btn-primary {
        background-color: #333333;
        color: white;
    }

    .btn-primary:hover {
        background-color: #333333;
    }

    .btn-secondary {
        background-color: #6c757d;
        color: white;
    }

    .btn-secondary:hover {
        background-color: #545b62;
    }
</style>
