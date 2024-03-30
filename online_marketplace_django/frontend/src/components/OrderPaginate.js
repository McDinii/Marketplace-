import React from 'react';
import { Pagination } from 'react-bootstrap';
import { LinkContainer } from 'react-router-bootstrap';

function PaginateOrder({ pages, page, isAdmin = false }) {
  const getPaginationNumbers = (currentPage, totalPages) => {
    const pagesToShow = 2; // количество страниц, отображаемых вокруг текущей
    let startPage = Math.max(1, currentPage - pagesToShow);
    let endPage = Math.min(totalPages, currentPage + pagesToShow);

    let pages = [];
    for (let i = startPage; i <= endPage; i++) {
      pages.push(i);
    }

    // Если первая страница не показана, добавляем её и символ пропуска
    if (startPage > 2) {
      pages.unshift('...');
      pages.unshift(1);
    } else if (startPage === 2) {
      pages.unshift(1);
    }

    // Если последняя страница не показана, добавляем её и символ пропуска
    if (endPage < totalPages - 1) {
      pages.push('...');
      pages.push(totalPages);
    } else if (endPage === totalPages - 1) {
      pages.push(totalPages);
    }

    return pages;
  };

  const paginationNumbers = getPaginationNumbers(page, pages);

  return (
    pages > 1 && (
      <Pagination>
        {paginationNumbers.map((x, index) =>
          isNaN(x) ? (
            <Pagination.Ellipsis key={index} />
          ) : (
            <LinkContainer
              key={x}
              to={isAdmin ? `/admin/orderlist/${x}` : `/orderlist/${x}`}
            >
              <Pagination.Item active={x === page}>{x}</Pagination.Item>
            </LinkContainer>
          )
        )}
      </Pagination>
    )
  );
}

export default PaginateOrder;
